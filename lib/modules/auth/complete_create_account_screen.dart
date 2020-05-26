import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CompleteCreateAccountScreen extends StatefulWidget {
  @override
  _CompleteCreateAccountScreenState createState() =>
      _CompleteCreateAccountScreenState();
}

class _CompleteCreateAccountScreenState
    extends State<CompleteCreateAccountScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> _fieldData;
  MaskedTextController _cpfController;
  TextEditingController _nameController;
  MaskedTextController _crmController;
  MaskedTextController _zipCodeController;
  TextEditingController _addressController;
  TextEditingController _houseNumberController;
  TextEditingController _adjunctController;
  TextEditingController _districtController;
  TextEditingController _cityController;

  _handleSubmit() {
    if (_formKey.currentState.validate()) {
      Modular.to.pushNamed(
        '/home/0',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _cpfController = MaskedTextController(
      mask: '000.000.000-00',
    );
    _nameController = TextEditingController();
    _crmController = MaskedTextController(
      mask: '000000-##',
    );
    _zipCodeController = MaskedTextController(
      mask: '000000-000',
    );
    _addressController = TextEditingController();

    _houseNumberController = TextEditingController();
    _adjunctController = TextEditingController();
    _districtController = TextEditingController();
    _cityController = TextEditingController();

    _fieldData = [
      {
        'labelText': 'CPF',
        'prefixIcon': Icon(
          Icons.person,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _cpfController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 14,
              message: 'CPF deve possuir 11 dígitos',
            ),
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Nome completo',
        'prefixIcon': Icon(
          MaterialCommunityIcons.domain,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _nameController,
        'validator': Helper.lengthValidator,
      },
      {
        'labelText': 'CRM',
        'prefixIcon': Icon(
          MaterialCommunityIcons.account_badge_horizontal,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _crmController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 9,
            ),
      },
      {
        'labelText': 'CEP',
        'controller': _zipCodeController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 10,
              message: 'CEP deve possuir 8 dígitos',
            ),
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Endereço',
        'controller': _addressController,
        'validator': Helper.lengthValidator,
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Número',
        'controller': _houseNumberController,
        'validator': Helper.lengthValidator,
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Complemento',
        'controller': _adjunctController,
        'validator': Helper.lengthValidator,
      },
      {
        'labelText': 'Bairro',
        'controller': _districtController,
        'validator': Helper.lengthValidator,
      },
      {
        'labelText': 'Cidade',
        'controller': _cityController,
        'validator': Helper.lengthValidator,
      },
    ];
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _crmController.dispose();
    _zipCodeController.dispose();
    _addressController.dispose();
    _houseNumberController.dispose();
    _adjunctController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Complete seu cadastro',
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Oftalmologista',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Preencha os campos abaixo para completar seu cadastro',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Column(
              children: _fieldData.take(3).map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFieldWidget(
                      labelText: e['labelText'],
                      prefixIcon: e['prefixIcon'],
                      controller: e['controller'],
                      validator: e['validator'],
                      keyboardType: e['keyboardType'],
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 30),
            Text(
              'Oftalmologista',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            Column(
              children: _fieldData.skip(3).map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFieldWidget(
                      labelText: e['labelText'],
                      prefixIcon: Icon(
                        MaterialCommunityIcons.map_marker,
                        color: Color(0xffA1A1A1),
                      ),
                      controller: e['controller'],
                      validator: e['validator'],
                      keyboardType: e['keyboardType'],
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: _handleSubmit,
              child: Text(
                'Completar Cadastro',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
