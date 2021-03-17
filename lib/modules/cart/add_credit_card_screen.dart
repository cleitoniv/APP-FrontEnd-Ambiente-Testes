import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../repositories/credit_card_repository.dart';

class AddCreditCardScreen extends StatefulWidget {
  final Map<String, dynamic> screen;

  AddCreditCardScreen({this.screen});

  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  TextEditingController _ownerController;
  MaskedTextController _creditCardNumberController;
  MaskedTextController _mesValidadeController;
  MaskedTextController _anoValidadeController;
  List<Map> _data;

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
      CreditCard _storeResult = await _creditCardBloc.addCreditCard(
        CreditCardModel(
          cartaoNumber: parseCartaoNumber(_creditCardNumberController.text),
          anoValidade: _anoValidadeController.text,
          mesValidade: _mesValidadeController.text,
          nomeTitular: _ownerController.text,
        ),
      );

      if (_storeResult.errorData != null) {
        SnackBar _snackBar = SnackBar(
          content: Text(
            'Falha ao adicionar cartão',
          ),
        );

        _scaffoldKey.currentState.showSnackBar(_snackBar);
      } else {
        Modular.to.popAndPushNamed("/cart/payment");
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
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
    _data = [
      {
        'labelText': 'Nome impresso no cartão',
        'capitalization': TextCapitalization.words,
        'icon': Icons.person,
        'controller': _ownerController,
        'validator': Helper.lengthValidator,
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
    _creditCardNumberController.dispose();
    _anoValidadeController.dispose();
    _mesValidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              children: _data.skip(2).map(
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
            SizedBox(height: 30),
            RaisedButton(
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Corrija os erros em vermelho antes de enviar.")));
                } else {
                  _onSubmit();
                }
              },
              child: Text(
                'Adicionar cartão',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }
}
