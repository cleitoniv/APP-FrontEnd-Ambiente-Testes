import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class DeliveryAddressRegisterScreen extends StatefulWidget {
  @override
  DeliveryAddressRegisterScreenState createState() =>
      DeliveryAddressRegisterScreenState();
}

class DeliveryAddressRegisterScreenState
    extends State<DeliveryAddressRegisterScreen> {
  @override
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MaskedTextController _zipCodeDeliveryController;
  TextEditingController _addressDeliveryController;
  TextEditingController _cityDeliveryController;
  TextEditingController _houseNumberDeliveryController;
  TextEditingController _districtDeliveryController;
  TextEditingController _ufDeliveryController;
  StreamSubscription atualizacaoEndereco;
  TextEditingController _adjunctDeliveryController;
  bool enabled = true;
  List<Map> _fieldAddressDelivery;
  FocusNode cepFocus = new FocusNode();

  String sanitize(String str) {
    return str.replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
  }

  _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> currentData = _authWidgetBloc.currentAccountData;

      Map<String, dynamic> completeFormdata = {
        'cep_entrega': sanitize(_zipCodeDeliveryController.text),
        'estado_entrega': sanitize(_ufDeliveryController.text),
        'endereco_entrega': _addressDeliveryController.text,
        'bairro_entrega': _districtDeliveryController.text,
        'cidade_entrega': _cityDeliveryController.text,
        'numero_entrega': _houseNumberDeliveryController.text,
        'complemento_entrega': _adjunctDeliveryController.text,
      };

      Map<String, dynamic> preFormData = await _authBloc.getFormData();

      _authBloc.createAccountIn.add(
        {...completeFormdata, ...preFormData},
      );

      LoginEvent createAccount = await _authBloc.createAccountOut.first;

      if (createAccount.isValid) {
        AuthEvent _cliente = await _authBloc.getCurrentUser(createAccount);

        if (_cliente.isValid) {
          Modular.to.pushNamedAndRemoveUntil(
            '/home/0',
            (route) => route.isFirst,
            arguments: _cliente,
          );
        } else {
          Modular.to.pushNamed('/auth/validate');
        }
      } else {
        SnackBar _snackBar = SnackBar(
          backgroundColor: Colors.white,
          content: Container(
            constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
            child: ListView(
              children: [
                Column(
                  children: createAccount.errorData.keys.map((e) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 3,
                                blurRadius: 3,
                                color: Colors.grey.withOpacity(0.1),
                                offset: Offset(0, 2))
                          ],
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${e}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(fontSize: 16)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ...createAccount.errorData[e].map((p) {
                                    return Text("${p}",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            fontSize: 15));
                                  })
                                ],
                              )
                            ],
                          )),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        );

        _scaffoldKey.currentState.showSnackBar(
          _snackBar,
        );
      }
    }
  }

  initState() {
    super.initState();
    _zipCodeDeliveryController = MaskedTextController(
      mask: '00000-000',
    );
    _addressDeliveryController = TextEditingController();
    _ufDeliveryController = TextEditingController();
    _houseNumberDeliveryController = TextEditingController();
    _adjunctDeliveryController = TextEditingController();
    _districtDeliveryController = TextEditingController();
    _cityDeliveryController = TextEditingController();
    _ufDeliveryController = TextEditingController();

    _fieldAddressDelivery = [
      {
        'labelText': 'CEP',
        'controller': _zipCodeDeliveryController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 8,
              message: 'CEP deve possuir 8 dígitos',
            ),
        'keyboardType': TextInputType.number,
        'enabled': this.enabled,
        'focus': cepFocus
      },
      {
        'labelText': 'Endereço',
        'controller': _addressDeliveryController,
        'validator': Helper.lengthValidator,
        'keyboardType': TextInputType.number,
        'enabled': this.enabled
      },
      {
        'labelText': 'Número',
        'controller': _houseNumberDeliveryController,
        'validator': Helper.lengthValidator,
        'keyboardType': TextInputType.number,
        'enabled': this.enabled
      },
      {
        'labelText': 'Complemento',
        'controller': _adjunctDeliveryController,
        'validator': null,
        'enabled': this.enabled
      },
      {
        'labelText': 'Estado',
        'controller': _ufDeliveryController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
      {
        'labelText': 'Cidade',
        'controller': _cityDeliveryController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
      {
        'labelText': 'Bairro',
        'controller': _districtDeliveryController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
    ];

    cepFocus.addListener(() async {
      if (!cepFocus.hasFocus) {
        await _authBloc.getEnderecoCep(_zipCodeDeliveryController.text);
      }
    });

    atualizacaoEndereco = _authBloc.enderecoStream.listen((event) {
      if (!event.isEmpty) {
        setState(() {
          _ufDeliveryController.text = event.endereco.uf;
          _zipCodeDeliveryController.text = event.endereco.cep;
          _addressDeliveryController.text = event.endereco.logradouro;
          _districtDeliveryController.text = event.endereco.bairro;
          _cityDeliveryController.text = event.endereco.localidade;
        });
      }
    });
  }

  @override
  void dispose() {
    _zipCodeDeliveryController.dispose();
    _addressDeliveryController.dispose();
    _houseNumberDeliveryController.dispose();
    _adjunctDeliveryController.dispose();
    _districtDeliveryController.dispose();
    _cityDeliveryController.dispose();
    super.dispose();
  }

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
        child: StreamBuilder(
          stream: _authWidgetBloc.createAccountDataOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                Text(
                  'Endereço de Entrega',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: _fieldAddressDelivery.map(
                    (e) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: TextFieldWidget(
                          focus: e['focus'],
                          labelText: e['labelText'],
                          prefixIcon: Icon(
                            MaterialCommunityIcons.map_marker,
                            color: Color(0xffA1A1A1),
                          ),
                          controller: e['controller'],
                          validator: e['validator'],
                          enabled: this.enabled,
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
            );
          },
        ),
      ),
    );
  }
}
