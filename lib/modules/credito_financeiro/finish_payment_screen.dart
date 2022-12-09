import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FinishPayment extends StatefulWidget {
  @override
  _FinishPaymentState createState() => _FinishPaymentState();
}

class _FinishPaymentState extends State<FinishPayment> {
  CreditoFinanceiroBloc _creditoFinanceiroBloc =
      Modular.get<CreditoFinanceiroBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  ExtractWidgetBloc _extract = Modular.get<ExtractWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  RequestsBloc _requestBloc = Modular.get<RequestsBloc>();
  TextEditingController _ccvController;
  MaskedTextController _creditCardNumberController;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _dropdownValueStatus = true;
  int _installmentsSelected = 1;
  String dropdownValue = '';
  bool _paymentMethod = true;
  List<String> _installments = [];
  bool _isButtonDisabled;
  bool _lock = false;

  _onSubmitDialog() {
    _requestBloc.getPedidosList(0);
    _authBloc.fetchCurrentUser();
    _extract.extractTypeIn.add("Financeiro");
    Modular.to.pushNamedAndRemoveUntil(
      '/extracts',
      (route) => route.isFirst,
    );
  }

  _onBack() {
    Modular.to.pop();
  }

  @override
  void initState() {
    super.initState();
    _creditCardNumberController = new MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    _ccvController = TextEditingController();
    _ccvController.addListener(() {});
    _calcPaymentInstallment();
    _getPaymentMethod();
    _isButtonDisabled = false;
  }

  @override
  void dispose() {
    super.dispose();
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
      _isButtonDisabled = true;
    });

    bool blocked = await _authBloc.currentUser();

    if (blocked) {
      setState(() {
        _lock = false;
        _isButtonDisabled = false;
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

    final _paymentMethod = _cartWidgetBloc.currentPaymentMethod;

    if (_ccvController.text.trim().length == 0 && !_paymentMethod.isBoleto) {
      setState(() {
        _lock = false;
        _isButtonDisabled = false;
      });

      _scaffoldKey.currentState.hideCurrentSnackBar();

      SnackBar _snackBar = SnackBar(
        content: Text(
          'Preencha o Código de Segurança do Cartão',
        ),
      );

      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return;
    }
    if (_paymentMethod.creditCard == null && !_paymentMethod.isBoleto) {
      return;
    }

    final CreditoFinanceiro creditoFinan =
        await _creditoFinanceiroBloc.creditoFinaceiroStream.first;

    if (mounted) {
      creditoFinan.installment = _installmentsSelected;

      bool statusPayment = await _creditoFinanceiroBloc.pagamento(
          creditoFinan, _paymentMethod.creditCard.id, _paymentMethod.isBoleto);

      setState(() {
        _lock = false;
      });
      if (statusPayment != null && statusPayment) {
        _cartWidgetBloc.cartTotalItemsSink.add(0);
        _requestBloc.resetCart();
        Dialogs.successWithWillPopScope(
          context,
          subtitle: 'Estamos processando seu pedido!',
          buttonText: 'Ir para Meus Pedidos',
          barrierDismissible: false,
          onTap: _onSubmitDialog,
        );
      } else {
        creditoFinan.installment = _installments.length;
        setState(() {
          _installmentsSelected = 1;
          _dropdownValueStatus = false;
        });
        Dialogs.error(
          context,
          title: "Atenção",
          subtitle: 'Erro ao Processar Compra! Verifique os dados do cartão!',
          buttonText: 'Voltar',
          onTap: _onBack,
        );
      }

      setState(() {
        _lock = false;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _lock = false;
        _isButtonDisabled = false;
      });
      SnackBar _snackBar = SnackBar(
        content: Text(
          'Estamos processando seu pedido!',
        ),
      );

      _scaffoldKey.currentState.showSnackBar(_snackBar);
    }
  }

  _calcPaymentInstallment() async {
    final creditoFinan =
        await _creditoFinanceiroBloc.creditoFinaceiroStream.first;

    final totalPay = Helper.intToMoney(creditoFinan.valor);
    setState(() {
      dropdownValue = '1x de $totalPay';
    });

    if (creditoFinan.installmentCount > 1) {
      for (var i = 1; i < creditoFinan.installmentCount + 1; i++) {
        var value = Helper.intToMoney((creditoFinan.valor / i).round());
        _installments.add("$i" + "x de $value");
      }
    } else {
      _installments.add('1x de $totalPay');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lock) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(133),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 16,
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
          body: GestureDetector(
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
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
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
                  ElevatedButton(
                    onPressed:
                        _isButtonDisabled ? null : _onSubmit, // _onSubmit,
                    child: Text(
                      'Finalizar Pedido',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
