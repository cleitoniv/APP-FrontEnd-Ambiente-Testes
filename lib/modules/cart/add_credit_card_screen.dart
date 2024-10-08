import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../repositories/vindi_repository.dart';
// import '../../repositories/credit_card_repository.dart';

class AddCreditCardScreen extends StatefulWidget {
  final Map<String, dynamic> screen;

  AddCreditCardScreen({this.screen});

  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  TextEditingController _ownerController;
  MaskedTextController _creditCardNumberController;
  MaskedTextController _ccvController;
  MaskedTextController _mesValidadeController;
  MaskedTextController _anoValidadeController;
  List<Map> _data;
  bool isLoading = false;

  String parseCartaoNumber(String number) {
    return number.replaceAll(" ", "");
  }

  _onSubmit() async {
    SnackBar _snackBar;
    DateTime now = new DateTime.now();
    if (int.parse(_mesValidadeController.text) < 1 ||
        int.parse(_mesValidadeController.text) > 12) {
      _snackBar = SnackBar(
        content: Text(
          'Mês de vencimento inválido.',
        ),
      );
      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return;
    }
    if (int.parse(_anoValidadeController.text) < now.year ||
        int.parse(_anoValidadeController.text) > now.year + 10) {
      _snackBar = SnackBar(
        content: Text(
          'Ano de vencimento inválido.',
        ),
      );
      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      VindiCreditCard _storeResult = await _creditCardBloc.addVindiCreditCard(
        CreditCardModel(
          cartaoNumber: parseCartaoNumber(_creditCardNumberController.text),
          anoValidade: _anoValidadeController.text,
          mesValidade: _mesValidadeController.text,
          nomeTitular: _ownerController.text,
          ccv: _ccvController.text,
        ),
      );
      print('passa linha 76');
      if (_storeResult.errorData != null) {
        SnackBar _snackBar = SnackBar(
          content: Text(
            'Cartão inválido',
          ),
        );
      setState(() {
        isLoading = false;
      });
        _scaffoldKey.currentState.showSnackBar(_snackBar);
      } else
      print('passa linha 88');
        await _creditCardBloc.addCreditCard(
          CreditCardModel(
            token: _storeResult.cartao.token,
          ),
        );

      if (_storeResult.errorData != null) {
        SnackBar _snackBar = SnackBar(
          content: Text(
            'Falha ao adicionar cartão',
          ),
        );
      setState(() {
        isLoading = false;
      });

        _scaffoldKey.currentState.showSnackBar(_snackBar);
      } else {
        await _creditCardBloc.fetchPaymentMethodsFinan();
        await _creditCardBloc.fetchPaymentMethods();
        Modular.to.pop();
        // Modular.to
        //     .pushReplacementNamed(widget.screen['route'] ?? '/cart/payment');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _creditCardBloc.fetchPaymentMethods();
    _ownerController = TextEditingController();
    _creditCardNumberController = MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    _mesValidadeController = MaskedTextController(
      mask: '00',
    );
    _anoValidadeController = MaskedTextController(
      mask: '0000',
    );
    _ccvController = MaskedTextController(
      mask: '000',
    );
    _data = [
      {
        'labelText': 'Nome impresso no cartão',
        'capitalization': TextCapitalization.characters,
        'icon': Icons.person,
        'controller': _ownerController,
        'validator': (text) => Helper.lengthValidatorContainsNumber(
              text,
            ),
      },
      {
        'labelText': 'Número do cartão',
        'icon': MaterialCommunityIcons.credit_card,
        'controller': _creditCardNumberController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 14,
              message: 'Número de cartão inválido',
            ),
        'keyboard_type': TextInputType.number
      },
      {
        'labelText': 'CCV',
        'icon': MaterialCommunityIcons.key,
        'controller': _ccvController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 3,
              message: 'CCV inválido',
            ),
        'keyboard_type': TextInputType.number
      },
      {
        'labelText': 'Mês',
        'icon': MaterialCommunityIcons.calendar_month,
        'controller': _mesValidadeController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 2,
              message: 'Data inválida',
            ),
        'keyboard_type': TextInputType.number
      },
      {
        'labelText': 'Ano',
        'icon': MaterialCommunityIcons.calendar_month,
        'controller': _anoValidadeController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 4,
              message: 'Ano inválido',
            ),
        'keyboard_type': TextInputType.number
      }
    ];
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _ccvController.dispose();
    _creditCardNumberController.dispose();
    _anoValidadeController.dispose();
    _mesValidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Scaffold(body: Center(child: CircularProgressIndicator()));
    // }
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar Cartão de Crédito'),
          centerTitle: false,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text(
                'Informações do Cartão',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: _data.take(2).length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  return TextFieldWidget(
                    labelText: _data[index]['labelText'],
                    textCapitalization: _data[index]['capitalization'],
                    prefixIcon: Icon(
                      _data[index]['icon'],
                      color: Color(0xffA1A1A1),
                    ),
                    validator: _data[index]['validator'],
                    controller: _data[index]['controller'],
                    keyboardType: _data[index]['keyboard_type'],
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _data.skip(3).map(
                  (e) {
                    return TextFieldWidget(
                      validator: e['validator'],
                      width: e['labelText'] == 'Validade do cartão'
                          ? MediaQuery.of(context).size.width / 2
                          : MediaQuery.of(context).size.width / 3.2,
                      labelText: e['labelText'],
                      prefixIcon: Icon(
                        e['icon'],
                        color: Color(0xffA1A1A1),
                      ),
                      controller: e['controller'],
                      keyboardType: e['keyboard_type'],
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  TextFieldWidget(
                    maxLength: 3,
                    width: 122,
                    labelText: _data[2]['labelText'],
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xffA1A1A1),
                    ),
                    validator: _data[2]['validator'],
                    controller: _data[2]['controller'],
                    keyboardType: _data[2]['keyboard_type'],
                  )
                ],
              ),
              SizedBox(height: 30),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Corrija os erros em vermelho antes de enviar.")));
                        } else {
                          _onSubmit();
                        }
                      },
                      child: Text(
                        'Adicionar Cartão',
                        style: Theme.of(context).textTheme.button,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
