// import 'dart:developer';

import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
// import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../blocs/auth_bloc.dart';
import '../../blocs/home_widget_bloc.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  RequestsBloc _requestBloc = Modular.get<RequestsBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  TextEditingController _ccvController;
  MaskedTextController _creditCardNumberController;
  AuthEvent currentUser;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _lock = true;
  bool billing = false;
  bool _onRefresh = false;
  bool _isLoading = false;

  int _valueToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["type"] == "T" ||
          element["tests"] == "Sim" ||
          element["operation"] == "13") {
        return previousValue;
      }
      return previousValue + element['product'].value * element['quantity'];
    });

    return _total;
  }

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _taxaEntrega = null;

    if (_requestBloc.taxaEntregaHasValue) {
      _taxaEntrega = _requestBloc.taxaEntregaValue;
    }

    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["operation"] == "03" ||
          element["operation"] == "13" ||
          element["tests"] == "Sim") {
        return previousValue;
      }
      return previousValue + element['product'].value * element['quantity'];
    });
    if (_taxaEntrega != null) return Helper.intToMoney(_total + _taxaEntrega);

    return Helper.intToMoney(_total);
  }

  _onAddCreditCard() {
    Modular.to.pushNamed('/cart/addCreditCard',
        arguments: {"screen": "/cart/payment"});
  }

  _onDelete(int id) async {
    RemoveCard _removeCard = await _creditCardBloc.removeCard(id);
    if (_removeCard.success) {
      Map<String, dynamic> success = {
        "Cartao Removido": [_removeCard.message]
      };
      setState(() {
        _isLoading = false;
      });
      _creditCardBloc.fetchPaymentMethods();

      // SnackBar _snackbar = SuccessSnackBar.snackBar(this.context, success);
      // inspect(_snackbar);
      // print('linha 90');
      // _scaffoldKey.currentState.showSnackBar(_snackbar);
    } else {
      Map<String, dynamic> success = {
        "Atenção": [_removeCard.message]
      };
      SnackBar _snackbar = ErrorSnackBar.snackBar(this.context, success);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    }
  }

  _onChangePaymentForm(VindiCardModel creditCard) async {
    setState(() {
      billing = false;
      _lock = false;
    });
    bool updated = await _cartWidgetBloc.setPaymentMethodCartao(creditCard);

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _lock = false;
      });
    });
  }

  _blockFinaliza() {
    if (!_lock && !billing) {
      Future.delayed(
          Duration.zero,
          () => setState(() {
                _lock = true;
              }));
    }
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
    this.currentUser = _authBloc.getAuthCurrentUser;
    _creditCardBloc.fetchPaymentMethodsFinan();
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
    super.dispose();
  }

  _finishPayment(List<Map> cartData) {
    _homeWidgetBloc.currentCreditTypeIn.add('Financeiro');
    if (_valueToPay(cartData) <= 0) {
      Dialogs.errorWithWillPopScope(context,
          barrierDismissible: false,
          title: "Valor inválido",
          subtitle: "Não é possivel realizar a compra com o valor selecionado.",
          buttonText: "OK", onTap: () {
        Modular.to.pop();
      });
      return;
    }

    CreditCardList cards =
        _creditCardBloc.cartaoCreditoValue ?? CreditCardList(list: []);

    if ((cards.list ?? []).length <= 0 && !billing) {
      Map<String, dynamic> error = {
        "Atenção": ["Voce precisa selecionar um meio de pagamento!"]
      };
      SnackBar _snackbar = ErrorSnackBar.snackBar(this.context, error);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    } else {
      Modular.to.pushNamed("/cart/finishPayment");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cartWidgetBloc.currentPaymentFormValue != null) {
      setState(() {
        _lock = false;
      });
    }
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(145),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
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
          body: StreamBuilder(
            stream: _creditCardBloc.cartaoCreditoStream,
            builder: (context, snapshot) {
              print('linha 268');

              if (!snapshot.hasData ||
                  (snapshot.hasData && snapshot.data.isLoading)) {
                // if (_isLoading) {
                //   return Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("Carregando Aguarde...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 16))
                          ])
                    ]);
              }
              final _creditCards = snapshot.data.list;
              return Column(
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
                                if (!snapshot.hasData ||
                                    snapshot.data.isLoading) {
                                  return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: CircularProgressIndicator()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Carregando cartões...",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(fontSize: 16))
                                            ])
                                      ]);
                                } else if (!snapshot.hasData ||
                                    snapshot.data.isEmpty) {
                                  return Center(
                                    child: Text(
                                      "Cadastre um cartão.",
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
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 15,
                                  ),
                                  itemBuilder: (context, index) {
                                    return StreamBuilder(
                                      stream:
                                          _cartWidgetBloc.currentPaymentFormOut,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          decoration: BoxDecoration(
                                            color: !_currentPaymentForm
                                                        .isEmpty &&
                                                    _currentPaymentForm
                                                            .creditCard !=
                                                        null &&
                                                    _colorizeCredCardList(
                                                        _currentPaymentForm
                                                            .creditCard.token,
                                                        _creditCards[index]
                                                            .token)
                                                ? Theme.of(context).accentColor
                                                : Color(0xffF1F1F1),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: ListTileMoreCustomizable(
                                            onTap: (value) {
                                              if (_currentPaymentForm.isEmpty) {
                                                setState(() {
                                                  _lock = false;
                                                });
                                              }
                                              print('linha 356');
                                              _onChangePaymentForm(
                                                _creditCards[index],
                                              );
                                            },
                                            contentPadding:
                                                const EdgeInsets.all(0),
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
                                                    _creditCardNumberController
                                                        .text),
                                                style:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: !_currentPaymentForm.isEmpty &&
                                                                  !snapshot.data
                                                                      .isBoleto &&
                                                                  _currentPaymentForm.creditCard !=
                                                                      null &&
                                                                  _colorizeCredCardList(
                                                                      _currentPaymentForm
                                                                          .creditCard
                                                                          .token,
                                                                      _creditCards[
                                                                              index]
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
                                                  _creditCards[index].token !=
                                                          null
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
                                                      color: Colors.red
                                                          .withOpacity(0.7),
                                                    ),
                                                    onPressed: () {
                                                      print('linha 430');
                                                      print(_isLoading);

                                                      setState(() {
                                                        _isLoading = true;
                                                      });

                                                      print(_creditCards[index]
                                                          .id);
                                                      _onDelete(
                                                          _creditCards[index]
                                                              .id);
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
                  this.currentUser.data.modPagamento == "2" ? Padding(
                    padding: EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          _lock = true;
                        });
                        Future.delayed(
                          const Duration(milliseconds: 1000),
                          () {
                            setState(() {
                              billing = true;
                              _lock = false;
                              _cartWidgetBloc.setPaymentMethodBoleto(billing);
                            });
                          },
                        );
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                'Boleto',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          billing ? Colors.white : Colors.black,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ) : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(245, 35),
                        primary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      onPressed: _onAddCreditCard,
                      icon: Icon(
                        MaterialCommunityIcons.plus,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        'Adicionar Cartã',
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: StreamBuilder(
                      stream: _requestBloc.cartOut,
                      builder: (context, cartSnapshot) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(245, 35),
                          ),
                          onPressed: _lock
                              ? null
                              : () {
                                  _finishPayment(cartSnapshot.data ?? []);
                                },
                          child: Text(
                            'Finalizar Pedido',
                            style: Theme.of(context).textTheme.button,
                            //
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          )),
    );
  }
}
