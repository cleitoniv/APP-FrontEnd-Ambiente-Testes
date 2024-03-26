import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
// import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
// import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../blocs/credit_bloc.dart';

class FinishPayment extends StatefulWidget {
  @override
  _FinishPaymentState createState() => _FinishPaymentState();
}

class _FinishPaymentState extends State<FinishPayment> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  PaymentBloc _paymentBloc = Modular.get<PaymentBloc>();
  RequestsBloc _requestBloc = Modular.get<RequestsBloc>();
  TextEditingController _ccvController;
  MaskedTextController _creditCardNumberController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _lock = false;
  bool _dropdownValueStatus = true;
  int _installmentsSelected = 1;
  String dropdownValue = '';
  int _totalPay = 0;
  bool _paymentMethod = true;
  List<String> _installments = [];
  List<String> _installmentsCart = [];

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["type"] == "T" ||
          element["tests"] == "Sim" ||
          element["operation"] == "13") {
        return previousValue;
      }
      return previousValue + element['product'].value * element['quantity'];
    });

    return Helper.intToMoney(_total);
  }

  int _totalToPayNumeric(List<Map<String, dynamic>> data) {
    return data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["operation"] == "03" ||
          element["tests"] == "Sim" ||
          element["operation"] == "13") {
        return previousValue;
      }
      return previousValue + element['product'].value * element['quantity'];
    });
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

  _removeItem() {
    int _total = _cartWidgetBloc.currentCartTotalItems;
    _cartWidgetBloc.cartTotalItemsSink.add(_total - _total);
  }

  @override
  void initState() {
    super.initState();
    _creditCardNumberController = new MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    _ccvController = TextEditingController();
    _calcPaymentInstallment();
    _getPaymentMethod();
  }

  @override
  void dispose() {
    _creditCardNumberController.dispose();
    _ccvController.dispose();
    super.dispose();
  }

  _getPaymentMethod() async {
    final paymentMethod = _cartWidgetBloc.currentPaymentFormValue;
    print('linha 105');

    setState(() {
      _paymentMethod = paymentMethod.isBoleto;
    });
  }

  _onSubmit(List<Map> cartData) async {
    print(cartData);
    if (_totalToPayNumeric(cartData) <= 0) {
      Dialogs.errorWithWillPopScope(context,
          barrierDismissible: false,
          title: "Valor inválido",
          subtitle: "Não é possivel realizar a compra com o valor selecionado.",
          buttonText: "OK", onTap: () {
        Modular.to.pop();
      });
      return;
    }

    bool blocked = await _authBloc.currentUser();

    if (blocked) {
      setState(() {
        _lock = true;
      });
      Dialogs.errorWithWillPopScope(context,
          barrierDismissible: false,
          buttonText: "OK",
          title: "Usuario bloqueado.",
          subtitle: "No momento voce não pode realizar esse tipo de operação.",
          onTap: () {
        Modular.to.pop();
      });
      return;
    }

    final _taxaEntrega = 0; //_requestBloc.taxaEntregaValue;
    final _paymentMethod = _cartWidgetBloc.currentPaymentFormValue;

    // return;

    if (_paymentMethod.creditCard == null && !_paymentMethod.isBoleto) {
      setState(() {
        _lock = true;
      });
      return;
    }
    final _cart = await _requestBloc.cartOut.first;

    int _value = int.parse(
      _totalToPay(_cart).replaceAll('.', '').replaceAll(',', ''),
    );

    bool statusPayment = await _paymentBloc.payment({
      'payment_data': _paymentMethod,
      'value': _value,
      'cart': _cart,
      'taxa_entrega': _taxaEntrega,
      'ccv': _ccvController.text,
      'installment': _installmentsSelected
    }, _paymentMethod.isBoleto);
    _ccvController.text = '';
    if (statusPayment != null && statusPayment == true) {
      _cartWidgetBloc.cartTotalItemsSink.add(0);
      _requestBloc.resetCart();
      Dialogs.successWithWillPopScope(
        context,
        barrierDismissible: false,
        subtitle: 'Compra efetuada com sucesso!',
        buttonText: 'Ir para Meus Pedidos',
        onTap: _onSubmitDialog,
      );
      _removeItem();
    } else {
      setState(() {
        _lock = false;
      });

      Dialogs.error(
        context,
        title: "Atenção",
        subtitle: 'Erro ao Processar Compra!',
        buttonText: 'Voltar',
        onTap: _onBack,
      );
    }
  }

  _getInstallmentCount(List cart, List<OfferModel> avulOffers, total) async {
    int creditCount = 1;
    int avulCont = 1;
    bool hasAvul = false;
    var mod =  await _cartWidgetBloc.currentPaymentFormValue;
    var key = mod.isBoleto ? 'installmentB' :  'installmentC';
    inspect(cart);

    for(var i = 0; i < cart.length; i++){
      if(cart[i]['operation'] == '01') hasAvul = true;
      print(cart[i][key]);
      if(cart[i][key] != null) {
        if(cart[i][key] > creditCount) {
          creditCount = cart[i][key];
        }
      }
    }

    if(hasAvul) {
      var minOffer = avulOffers.reduce((acc, offer) {
        if(acc.value < offer.value) {
          return acc;
        } else {
          return offer;
        }
      });
      inspect(minOffer);

      if(mod.isBoleto) {
        avulCont = minOffer.installmentCountB > 0 ? minOffer.installmentCountB : 1;
      } else {
        avulCont = minOffer.installmentCountC > 0 ? minOffer.installmentCountC : 1;
      }
      

      for(var i = 0; i < avulOffers.length; i++) {
        if(total > avulOffers[i].value) {
          avulCont = mod.isBoleto ? avulOffers[i].installmentCountB : avulOffers[i].installmentCountC;
        }
      }
    }
    print('parcelas ---------');
    print(avulCont);
    print(creditCount);
    return avulCont > creditCount ? avulCont : creditCount;
  }

  _calcPaymentInstallment() async {
    var avulseOffers;
    final _cart = await _requestBloc.cartOut.first;
    if (_cart[0]['operation'] == '01' || _cart[0]['operation'] == '04') {
     avulseOffers = await _creditsBloc.fetchAvulseOffersSync();   
    } 
    // else if (_cart[0]['operation'] == '06' || _cart[0]['operation'] == '07') {
    //   _creditsBloc.fetchCreditOfferSync()
    // } 

    final totalPay =  _totalToPayNumeric(_cart);

    final installmentCount = await _getInstallmentCount(_cart, avulseOffers?.offers, totalPay);
    setState(() {
      dropdownValue = '1x de ${Helper.intToMoney((totalPay).round())}';
    });

    if (installmentCount > 1) {
      for (var i = 1; i < installmentCount + 1; i++) {
        var value = Helper.intToMoney((totalPay / i).round());
        _installments.add("$i" + "x de $value");
      }
    } else {
      _installments.add('1x de ${Helper.intToMoney((totalPay).round())}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lock) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(
              height: 10,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 10,
              ),
              Text("Finalizando compra aguarde...",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 16))
            ])
          ]));
    }
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(135),
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
        body: StreamBuilder(
            stream: _cartWidgetBloc.currentPaymentFormOut,
            builder: (context, snapshot3) {
              if (!snapshot3.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parcelamento",
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 18,
                                    ),
                          ),
                          Container(
                            height: 20,
                          ),
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: _dropdownValueStatus
                                      ? dropdownValue
                                      : _installments[0],
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _dropdownValueStatus = true;
                                      _installmentsSelected =
                                          _installments.indexOf(newValue) + 1;
                                      dropdownValue = newValue;
                                    });
                                  },
                                  items: _installments
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          !snapshot3.data.isBoleto
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(height: 20),
                                  ],
                                )
                              : Container(height: 20),
                        ],
                      ),
                      StreamBuilder(
                        stream: _requestBloc.cartOut,
                        builder: (context, cartSnapshot) {
                          print(_lock);
                          return ElevatedButton(
                            onPressed: _lock
                                ? null
                                : () {
                                    setState(() {
                                      _lock = true;
                                    });
                                    _onSubmit(cartSnapshot.data ?? []);
                                  },
                            child: Text(
                              'Finalizar Pedido',
                              style: Theme.of(context).textTheme.button,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
