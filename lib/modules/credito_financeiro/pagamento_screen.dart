import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar_success.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../models/vindi_model.dart';

class CreditoPagamentoScreen extends StatefulWidget {
  @override
  _CreditoPagamentoScreenState createState() => _CreditoPagamentoScreenState();
}

class _CreditoPagamentoScreenState extends State<CreditoPagamentoScreen> {
  CreditoFinanceiroBloc _creditoFinanceiroBloc =
      Modular.get<CreditoFinanceiroBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _onRefresh = false;
  bool billing = false;
  bool _lock = false;
  MaskedTextController _creditCardNumberController;

  _onAddCreditCard() {
    Modular.to.pushNamed('/cart/addCreditCard',
        arguments: {'route': '/credito_financeiro/pagamento'});
  }

  _onChangePaymentForm(VindiCardModel creditCard) async {
    setState(() {
      billing = false;
      _lock = true;
    });
    bool selectedCard =
        await _cartWidgetBloc.setPaymentMethodCartao(creditCard);
    if (selectedCard) {
      _creditCardBloc.fetchPaymentMethodsChange();
    }

    setState(() {
      billing = false;
      _lock = false;
    });
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

  _colorizeCredCardList(index, idSelected) {
    if (index == idSelected && !billing) {
      return true;
    }
    return false;
  }

  _finishPayment() {
    CreditCardList cards =
        _creditCardBloc.cartaoCreditoValue ?? CreditCardList(list: []);

    if ((cards.list ?? []).length <= 0) {
      Map<String, dynamic> error = {
        "Atenção": ["Voce precisa selecionar um meio de pagamento!"]
      };
      SnackBar _snackbar = ErrorSnackBar.snackBar(this.context, error);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    } else {
      Modular.to.pushNamed("/credito_financeiro/finishPayment");
    }
  }

  _blockFinaliza() {
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _lock = true;
            }));
  }

  @override
  void initState() {
    super.initState();
    _creditCardBloc.fetchPaymentMethodsFinan();
    _creditCardNumberController = new MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _creditCardNumberController.dispose();
  }

  _obfuscateText(String text) {
    var numOriginal = text.split(" ");
    numOriginal[1] = "****";
    numOriginal[2] = "****";
    var numObfuscated = numOriginal.join(",");
    return numObfuscated.replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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
                      StreamBuilder(
                        stream: _creditoFinanceiroBloc.creditoFinaceiroStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            'R\$ ${Helper.intToMoney(snapshot.data.valor)}',
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
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _onRefresh = true;
                  });
                  await _creditCardBloc.fetchPaymentMethods();
                  setState(() {
                    _onRefresh = false;
                  });
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  children: <Widget>[
                    StreamBuilder(
                        stream: _creditCardBloc.cartaoCreditoStream,
                        builder: (context, snapshot) {
                          if (_onRefresh) {
                            return Container();
                          }
                          if ((!snapshot.hasData || snapshot.data.isLoading)) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data.isEmpty) {
                            // _blockFinaliza();
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
                                stream: _cartWidgetBloc.currentPaymentFormOut,
                                builder: (context, snapshot) {
                                  PaymentMethod _currentPaymentForm;
                                  if (!snapshot.hasData) {
                                    _currentPaymentForm =
                                        PaymentMethod(isEmpty: true);
                                  } else {
                                    _currentPaymentForm = snapshot.data;
                                  }
                                  _creditCardNumberController.updateText(
                                      _creditCards[index].cartaoNumber);

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
                                      color: !_currentPaymentForm.isEmpty &&
                                              _colorizeCredCardList(
                                                  _currentPaymentForm
                                                      .creditCard.token,
                                                  _creditCards[index].token)
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
                                      title: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          _obfuscateText(
                                              _creditCardNumberController.text),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: !_currentPaymentForm
                                                            .isEmpty &&
                                                        _colorizeCredCardList(
                                                            _currentPaymentForm
                                                                .creditCard
                                                                .token,
                                                            _creditCards[index]
                                                                .token)
                                                    ? Colors.white
                                                    : null,
                                              ),
                                        ),
                                      ),
                                      trailing: Container(
                                        height: 50,
                                        width: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _creditCards[index].token != null
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
                                                _onDelete(
                                                    _creditCards[index].token);
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
            ),
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: GestureDetector(
            //     onTap: () {
            //       setState(() {
            //         billing = true;
            //         _cartWidgetBloc.setPaymentMethodBoleto(billing);
            //       });
            //     },
            //     child: Container(
            //       height: 50,
            //       decoration: BoxDecoration(
            //         color: billing
            //             ? Theme.of(context).accentColor
            //             : Color(0xffF1F1F1),
            //         borderRadius: BorderRadius.all(Radius.circular(5)),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black12,
            //             offset: Offset(0, 2),
            //             blurRadius: 10,
            //             spreadRadius: 1,
            //           ),
            //         ],
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(left: 25.0),
            //             child: Text(
            //               'Boleto',
            //               style: Theme.of(context).textTheme.subtitle1.copyWith(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w600,
            //                     color: null,
            //                   ),
            //             ),
            //           ),
            //           IconButton(
            //             icon: Icon(
            //               Icons.check,
            //               color: Colors.black,
            //             ),
            //             onPressed: () {
            //               setState(() {
            //                 billing = true;
            //                 _cartWidgetBloc.setPaymentMethodBoleto(billing);
            //               });
            //             },
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ElevatedButton.icon(
                onPressed: _onAddCreditCard,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
                icon: Icon(
                  MaterialCommunityIcons.plus,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  'Adicionar Outro Cartão',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(245, 35),
                ),
                onPressed: _lock ? null : _finishPayment,
                child: Text(
                  'Finalizar Pedido',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
