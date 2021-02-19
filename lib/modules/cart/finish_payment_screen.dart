import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar_success.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../repositories/credit_card_repository.dart';
import '../../widgets/snackbar.dart';

class FinishPayment extends StatefulWidget {
  @override
  _FinishPaymentState createState() => _FinishPaymentState();
}

class _FinishPaymentState extends State<FinishPayment> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
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

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["type"] == "T" ||
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
          element["operation"] == "00" ||
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
  }

  _getPaymentMethod() async {
    final paymentMethod = _cartWidgetBloc.currentPaymentMethod;
    setState(() {
      _paymentMethod = paymentMethod.isBoleto;
    });
  }

  _onSubmit() async {
    setState(() {
      _lock = true;
    });
    final _taxaEntrega = 0; //_requestBloc.taxaEntregaValue;
    final _paymentMethod = _cartWidgetBloc.currentPaymentMethod;
    if (_ccvController.text.trim().length == 0 && !_paymentMethod.isBoleto) {
      SnackBar _snackBar = SnackBar(
        content: Text(
          'Preencha o Código de Segurança do Cartão',
        ),
      );

      _scaffoldKey.currentState.showSnackBar(_snackBar);
      setState(() {
        _lock = false;
      });
      return;
    }

    if (_paymentMethod.creditCard == null && !_paymentMethod.isBoleto) {
      setState(() {
        _lock = false;
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
      _requestBloc.resetCart();
      Dialogs.success(
        context,
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

  _calcPaymentInstallment() async {
    final _paymentMethod = await _cartWidgetBloc.currentPaymentMethod;

    final _cart = await _requestBloc.cartOut.first;
    setState(() {
      _totalPay = int.parse(
        _totalToPay(_cart).replaceAll('.', '').replaceAll(',', ''),
      );
    });

    final _installmentsList = await _creditCardBloc.fetchInstallments(
        _totalToPayNumeric(_cart), _paymentMethod.isBoleto);

    if (_installmentsList.length > 0) {
      setState(() {
        dropdownValue = _installmentsList[0]['parcela'];
      });

      for (var item in _installmentsList) {
        _installments.add(item['parcela'].toString());
      }
    } else {
      dropdownValue = '1x $_totalPay';
      _installments.add('1x $_totalPay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Parcelamento",
                    style: Theme.of(context).textTheme.headline5.copyWith(
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                              .map<DropdownMenuItem<String>>((String value) {
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
                  !_paymentMethod
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Código CCV do Cartão",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 18),
                            ),
                            Container(height: 20),
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
                              child: TextFieldWidget(
                                controller: _ccvController,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Color(0xffA1A1A1),
                                ),
                                width: 120,
                                keyboardType: TextInputType.number,
                              ),
                            )
                          ],
                        )
                      : Container(height: 20),
                ],
              ),
              RaisedButton(
                onPressed: !_lock ? _onSubmit : null, // _onSubmit,
                child: Text(
                  'Finalizar Pedido',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ));
  }
}
