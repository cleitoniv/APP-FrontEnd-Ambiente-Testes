import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../repositories/credit_card_repository.dart';
import '../../widgets/snackbar.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  PaymentBloc _paymentBloc = Modular.get<PaymentBloc>();
  RequestsBloc _requestBloc = Modular.get<RequestsBloc>();
  TextEditingController _ccvController;
  MaskedTextController _creditCardNumberController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _lock = false;
  bool billing = false;

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _taxaEntrega = _requestBloc.taxaEntregaValue;
    int _total = data.fold(
      0,
      (previousValue, element) =>
          previousValue + element['product'].value * element['quantity'],
    );
    return Helper.intToMoney(_total + _taxaEntrega);
  }

  _onAddCreditCard() {
    Modular.to.pushNamed('/cart/addCreditCard');
  }

  _onDelete(int id) async {
    RemoveCard _removeCard = await _creditCardBloc.removeCard(id);
    if (_removeCard.success) {
      Map<String, dynamic> success = {
        "Cartao Removido": [_removeCard.message]
      };
      _creditCardBloc.fetchPaymentMethods();

      SnackBar _snackbar = SuccessSnackBar.snackBar(this.context, success);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    } else {
      Map<String, dynamic> success = {
        "Atenção": [_removeCard.message]
      };
      SnackBar _snackbar = ErrorSnackBar.snackBar(this.context, success);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    }
  }

  _onChangePaymentForm(CreditCardModel creditCard) async {
    setState(() {
      billing = false;
    });
    bool selectedCard =
        await _cartWidgetBloc.setPaymentMethodCartao(creditCard);
    if (selectedCard) {
      _creditCardBloc.fetchPaymentMethods();
    }
  }

  _onSubmitDialog() {
    _requestBloc.getPedidosList(0);
    _authBloc.fetchCurrentUser();
    Modular.to.pushNamedAndRemoveUntil(
      '/home/3',
      (route) => route.isFirst,
    );
  }

  _onBack() {
    Modular.to.pop();
  }

  _blockFinaliza() {
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _lock = true;
            }));
  }

  _obfuscateText(String text) {
    var numOriginal = text.split(" ");
    numOriginal[1] = "****";
    numOriginal[2] = "****";
    var numObfuscated = numOriginal.join(",");
    return numObfuscated.replaceAll(',', ' ');
  }

  _colorizeCredCardList(index, idSelected) {
    if (index == idSelected && !billing) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _creditCardBloc.fetchPaymentMethods();
    _creditCardNumberController = new MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    _ccvController = TextEditingController();
  }

  @override
  void dispose() {
    _creditCardNumberController.dispose();
    _ccvController.dispose();
  }

  _onSubmit() async {
    final _paymentMethod = await _cartWidgetBloc.currentPaymentMethod;

    final _cart = await _requestBloc.cartOut.first;

    int _value = int.parse(
      _totalToPay(_cart).replaceAll('.', '').replaceAll(',', ''),
    );
    bool statusPayment = await _paymentBloc.payment({
      'payment_data': _paymentMethod,
      'value': _value,
      'cart': _cart,
      'ccv': _ccvController.text
    }, billing);
    _ccvController.text = '';
    if (statusPayment != null && statusPayment == true) {
      _requestBloc.resetCart();
      Dialogs.success(
        context,
        subtitle: 'Compra efetuada com sucesso!',
        buttonText: 'Ir para Meus Pedidos',
        onTap: _onSubmitDialog,
      );
    } else {
      Dialogs.error(
        context,
        title: "Atenção",
        subtitle: 'Erro ao Processar Compra! Verifique os dados do cartão!',
        buttonText: 'Voltar',
        onTap: _onBack,
      );
    }
  }

  _finishPayment() {
    Modular.to.pushNamed("/cart/finishPayment");
  }

  _showCcvDialog() async {
    final _paymentMethod = await _cartWidgetBloc.currentPaymentMethod;

    if (_paymentMethod.creditCard == null) {
      return;
    }
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: _ccvController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Digite o Código de Segurança', hintText: '000'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(child: const Text('ENVIAR'), onPressed: _onSubmit),
          new FlatButton(
              child: const Text('CANCELAR'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppBar(
                  title: Text('Pagamento'),
                  centerTitle: false,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _requestBloc.cartOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            'R\$ ${_totalToPay(snapshot.data)}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 18,
                                    ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                children: <Widget>[
                  StreamBuilder(
                      stream: _creditCardBloc.cartaoCreditoStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                          if (!billing) {
                            _blockFinaliza();
                          }
                          return Center(
                            child: Text(
                              "Cadastre um cartão!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 20),
                            ),
                          );
                        }
                        final _creditCards = snapshot.data.list;

                        return ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _creditCards.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15,
                          ),
                          itemBuilder: (context, index) {
                            return StreamBuilder(
                              stream: _creditCardBloc.currentPaymentFormOut,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }

                                final _currentPaymentForm = snapshot.data;

                                _creditCardNumberController.updateText(
                                    _creditCards[index].cartao_number);
                                return AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: 100,
                                  ),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _colorizeCredCardList(
                                            _currentPaymentForm.id,
                                            _creditCards[index].id)
                                        ? Theme.of(context).accentColor
                                        : Color(0xffF1F1F1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListTileMoreCustomizable(
                                    onTap: (value) => _onChangePaymentForm(
                                      _creditCards[index],
                                    ),
                                    contentPadding: const EdgeInsets.all(0),
                                    horizontalTitleGap: 10,
                                    // leading: Image.asset(
                                    //   'assets/icons/barcode.png',
                                    //   width: 30,
                                    //   height: 25,
                                    //   fit: BoxFit.contain,
                                    // ),
                                    leading: Icon(
                                      Icons.credit_card,
                                    ),
                                    title: Text(
                                      _obfuscateText(
                                          _creditCardNumberController.text),
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: _colorizeCredCardList(
                                                    _currentPaymentForm.id,
                                                    _creditCards[index].id)
                                                ? Colors.white
                                                : null,
                                          ),
                                    ),
                                    trailing: Container(
                                      height: 50,
                                      width: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          _currentPaymentForm.id ==
                                                  _creditCards[index].id
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 25,
                                                )
                                              : Container(
                                                  width: 25,
                                                ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color:
                                                  Colors.red.withOpacity(0.7),
                                            ),
                                            onPressed: () {
                                              _onDelete(_creditCards[index].id);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    billing = true;
                    this._lock = false;
                    _cartWidgetBloc.setPaymentMethodBoleto(billing);
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: billing
                        ? Theme.of(context).accentColor
                        : Color(0xffF1F1F1),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Boleto',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: null,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: RaisedButton.icon(
                  onPressed: _onAddCreditCard,
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  icon: Icon(
                    MaterialCommunityIcons.plus,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    'Adicionar Outro Cartão',
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: !_lock
                      ? _finishPayment
                      : null, // _showCcvDialog  _onSubmit,
                  child: Text(
                    'Finalizar Pedido',
                    style: Theme.of(context).textTheme.button,
                  )),
            )
          ],
        ));
  }
}
