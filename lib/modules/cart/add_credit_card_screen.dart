import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddCreditCardScreen extends StatefulWidget {
  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreditCardBloc _creditCardBloc = Modular.get<CreditCardBloc>();
  TextEditingController _ownerController;
  MaskedTextController _creditCardNumberController;
  MaskedTextController _validityController;
  MaskedTextController _securityCodeController;
  List<Map> _data;

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _creditCardBloc.storeIn.add(
        CreditCardModel(
          number: _creditCardNumberController.text,
          validity: _validityController.text,
          securityCode: _securityCodeController.text,
          owner: _ownerController.text,
        ),
      );

      String _data = await _creditCardBloc.storeOut.first;

      if (_data != null) {
        SnackBar _snackBar = SnackBar(
          content: Text(
            'Cartão de crédito adicionado com sucesso',
          ),
        );

        _scaffoldKey.currentState.showSnackBar(_snackBar);

        await Future.delayed(
          Duration(seconds: 2),
        );
        Modular.to.pop();
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
    _validityController = MaskedTextController(
      mask: '00/00',
    );
    _securityCodeController = MaskedTextController(
      mask: '000',
    );
    _data = [
      {
        'labelText': 'Nome impresso no cartão',
        'icon': Icons.person,
        'controller': _ownerController,
        'validator': Helper.lengthValidator,
      },
      {
        'labelText': 'Número do cartãoo',
        'icon': MaterialCommunityIcons.credit_card,
        'controller': _creditCardNumberController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 14,
              message: 'Número de cartão inválido',
            ),
      },
      {
        'labelText': 'Validade do cartão',
        'icon': MaterialCommunityIcons.calendar_month,
        'controller': _validityController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 5,
              message: 'Data inválida',
            ),
      },
      {
        'labelText': 'CVV',
        'icon': MaterialCommunityIcons.card_bulleted,
        'controller': _securityCodeController,
        'validator': (text) => Helper.lengthValidator(
              text,
              length: 3,
              message: 'Código inválido',
            ),
      }
    ];
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _creditCardNumberController.dispose();
    _validityController.dispose();
    _securityCodeController.dispose();
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
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: _onSubmit,
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
