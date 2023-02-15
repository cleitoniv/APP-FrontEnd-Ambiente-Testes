import 'dart:async';

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

class CompleteCreateAccountScreen extends StatefulWidget {
  @override
  _CompleteCreateAccountScreenState createState() =>
      _CompleteCreateAccountScreenState();
}

class _CompleteCreateAccountScreenState
    extends State<CompleteCreateAccountScreen> {
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  MaskedTextController _cpfController;
  TextEditingController _nameController;
  MaskedTextController _cnaeController;
  MaskedTextController _crmController;
  MaskedTextController _zipCodeController;
  TextEditingController _addressController;
  TextEditingController _houseNumberController;
  TextEditingController _adjunctController;
  TextEditingController _districtController;
  TextEditingController _cityController;
  TextEditingController _cnpjController;
  TextEditingController _ufController;
  TextEditingController _codMunicipioController;
  TextEditingController _dataNascimentoController;
  TextEditingController _emailFiscalController;

  StreamSubscription atualizacaoEndereco;

  FocusNode cnpjFocus = new FocusNode();
  FocusNode cepFocus = new FocusNode();
  FocusNode otherFocus;

  bool enabled = true;
  bool cnaeCrmEnabled = true;
  bool dataNascimentoEnabled = true;
  bool numeroEnabled = true;
  bool complementEnabled = true;
  bool emailFiscalEnabled = true;
  String textRegister = 'Continuar Cadastro';
  // bool enderecoEnabled = false;

  String sanitize(String str) {
    return str.replaceAll('.', '').replaceAll('-', '').replaceAll('/', '');
  }

  bool isValidDate(String input) {
    SnackBar _snackBar;
    DateTime now = new DateTime.now();
    var splitDate = input.split("/");
    if (int.parse(splitDate[2]) > (now.year - 18)) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }
    if (int.parse(splitDate[2]) <= 1900) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }

    var splitedDate = "${splitDate[2]}${splitDate[1]}${splitDate[0]}";

    final date = DateTime.parse(splitedDate);
    final originalFormatString = toOriginalFormatString(date);
    if (!(splitedDate == originalFormatString)) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }
    if (_snackBar != null) {
      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return true;
    }
    return false;
  }

  void clienteExiste(String cpfCnpj) async {
    Cadastro cadastro = await _authBloc.fetchCadastro(sanitize(cpfCnpj));
    if (!cadastro.isEmpty) {
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
          Modular.to.pushNamed('/auth/loginprocess');
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
                                  Text(
                                    "$e",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ...createAccount.errorData[e].map((p) {
                                    return Text(
                                      "$p",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 15),
                                    );
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

        _scaffoldKey.currentState.showSnackBar(_snackBar);
      }
    } else {
      Modular.to.pushNamed('/auth/deliveryAddressRegister');
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  _handleSubmit() async {
    if (_dataNascimentoController.text == "") {
    } else if (isValidDate(_dataNascimentoController.text)) {
      return;
    }

    if (_cnpjController.text.length <= 13 &&
        !_verifyCpfCnpj(_cpfController.text, "CPF")) {
      return;
    } else if (_cnpjController.text.length >= 13 &&
        !_verifyCpfCnpj(_cnpjController.text, "CNPJ")) {
      return;
    }
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> currentData = _authWidgetBloc.currentAccountData;
      final cnpjCpf = cpfCnpjLabel(currentData["ramo"]);

      Map<String, dynamic> completeFormdata = {
        'nome': sanitize(_nameController.text),
        'cep': sanitize(_zipCodeController.text),
        'estado': sanitize(_ufController.text),
        'cdmunicipio': _codMunicipioController.text,
        'endereco': _addressController.text,
        'bairro': _districtController.text,
        'municipio': _cityController.text,
        'numero': _houseNumberController.text,
        'crm_medico': sanitize(_crmController.text),
        'cod_cnae': sanitize(_cnaeController.text),
        'nome_empresarial': sanitize(_nameController.text),
        'complemento': _adjunctController.text,
        'data_nascimento': _dataNascimentoController.text,
        'email_fiscal': _emailFiscalController.text
      };

      if (cnpjCpf["ramo"] == "CPF") {
        completeFormdata['cnpj_cpf'] = sanitize(_cpfController.text);
      } else {
        completeFormdata['cnpj_cpf'] = sanitize(_cnpjController.text);
      }

      Map<String, dynamic> preFormData =
          await _authWidgetBloc.createAccountDataOut.first;

      _authBloc.createAccountIn.add(
        {...completeFormdata, ...preFormData},
      );
      clienteExiste(_cpfController.text);
    }
  }

  bool _verifyCpfCnpj(String cpfCnpj, String type) {
    if (type == "CPF") {
      if (!CPF.isValid(cpfCnpj)) {
        _showDialog("Atenção", "$type inválido ou incompleto.");
        return false;
      }
      return true;
    } else {
      if (!CNPJ.isValid(cpfCnpj)) {
        _showDialog("Atenção", "$type inválido ou incompleto.");
        return false;
      }
    }
    return true;
  }

  _showDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text(content),
          actions: [
            ElevatedButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Modular.to.pop();
                })
          ],
        );
      },
    );
  }

  List<Map> registerAddressTerms() {
    List<Map> _fieldData = [
      {
        'labelText': 'CEP',
        'controller': _zipCodeController,
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
        'controller': _addressController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
      {
        'labelText': 'Número',
        'controller': _houseNumberController,
        'validator': Helper.lengthValidator,
        'keyboardType': TextInputType.number,
        'enabled': this.numeroEnabled
      },
      {
        'labelText': 'Complemento',
        'controller': _adjunctController,
        'validator': null,
        'enabled': this.complementEnabled
      },
      {
        'labelText': 'Estado',
        'controller': _ufController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
      {
        'labelText': 'Cidade',
        'controller': _cityController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
      {
        'labelText': 'Bairro',
        'controller': _districtController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
      },
    ];

    return _fieldData;
  }

  Map<String, dynamic> cpfCnpjLabel(String ramo) {
    switch (ramo) {
      case "2":
        {
          return {'ramo': "CNPJ", 'controller': _cnpjController};
        }
        break;
      case "3":
        {
          return {'ramo': "CNPJ", 'controller': _cnpjController};
        }
        break;
      default:
        {
          return {'ramo': "CPF", 'controller': _cpfController};
        }
    }
  }

  List<Map> defineCadastralTerms(String ramo) {
    final cnpjCpf = cpfCnpjLabel(ramo);

    List<Map> basicFields = [
      {
        'labelText': cnpjCpf['ramo'],
        'prefixIcon': Icon(
          Icons.person,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': cnpjCpf['controller'],
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 11,
              message: 'CPF deve possuir 11 dígitos',
            ),
        'keyboardType': TextInputType.number,
        'focus': cnpjFocus,
        'enabled': true
      },
      {
        'labelText': 'Nome completo',
        'textCapitalization': TextCapitalization.words,
        'prefixIcon': Icon(
          MaterialCommunityIcons.domain,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _nameController,
        'validator': Helper.lengthValidator,
        'enabled': this.enabled
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
              length: 6,
            ),
        'enabled': this.cnaeCrmEnabled
      },
      {
        'labelText': "Data de Nascimento",
        'prefixIcon': Icon(
          Icons.calendar_today,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _dataNascimentoController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 10,
            ),
        'keyboardType': TextInputType.number,
        'enabled': this.dataNascimentoEnabled
      },
      {
        'labelText': 'Email para info. Fiscais',
        'prefixIcon': Icon(
          Icons.email,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _emailFiscalController,
        'validator': Helper.emailValidator,
        'keyboardType': TextInputType.emailAddress,
        'enabled': this.emailFiscalEnabled
      },
      {
        'labelText': "CNAE",
        'prefixIcon': Icon(
          Icons.person,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _cnaeController,
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 9,
            ),
        'keyboardType': TextInputType.text,
        'enabled': this.cnaeCrmEnabled
      },
    ];

    if (ramo != "2" && ramo != "3") {
      basicFields.removeLast();
      return basicFields;
    } else {
      return basicFields.where((el) => el["labelText"] != "CRM").toList();
    }
  }

  void completeCadastro(TextEditingController controller) async {
    Cadastro cadastro =
        await _authBloc.fetchCadastro(sanitize(controller.text));
    if (!cadastro.isEmpty) {
      _cnaeController.text = cadastro.dados.crmCnae;
      _crmController.text = cadastro.dados.crmCnae;
      _nameController.text = cadastro.dados.nome;
      _zipCodeController.text = cadastro.dados.cep;
      _addressController.text = cadastro.dados.endereco;
      _houseNumberController.text = cadastro.dados.numero;
      _adjunctController.text = cadastro.dados.complemento;
      _cityController.text = cadastro.dados.cidade;
      _districtController.text = cadastro.dados.bairro;
      _dataNascimentoController.text = cadastro.dados.dataNascimento;
      _ufController.text = cadastro.dados.estado;
      _emailFiscalController.text = cadastro.dados.emailFiscal;
      setState(() {
        if (cadastro.dados.crmCnae != '000000000') {
          this.cnaeCrmEnabled = true;
        }
        if (cadastro.dados.dataNascimento != null) {
          this.dataNascimentoEnabled = false;
        }
        if (cadastro.dados.emailFiscal != null) {
          this.emailFiscalEnabled = false;
        }
        if (cadastro.dados.emailFiscal != null) {
          this.emailFiscalEnabled = false;
        }
        if (cadastro.dados.numero != null) {
          this.numeroEnabled = false;
        }
        if (cadastro.dados.complemento != null) {
          this.complementEnabled = false;
        }
        this.textRegister = 'Completar Cadastro';
        this.enabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');
    _cpfController = MaskedTextController(
      mask: '000.000.000-00',
    );
    _cnaeController = MaskedTextController(
      mask: '00.00-0-00',
    );
    _nameController = TextEditingController();
    _crmController = MaskedTextController(
      mask: '0000-00',
    );
    _zipCodeController = MaskedTextController(
      mask: '00000-000',
    );
    _dataNascimentoController = MaskedTextController(mask: '00/00/0000');
    _addressController = TextEditingController();
    _ufController = TextEditingController();
    _houseNumberController = TextEditingController();
    _adjunctController = TextEditingController();
    _districtController = TextEditingController();
    _cityController = TextEditingController();
    _ufController = TextEditingController();
    _codMunicipioController = TextEditingController();
    _emailFiscalController = TextEditingController();

    otherFocus = new FocusNode();

    Map<String, dynamic> currentData = _authWidgetBloc.currentAccountData;

    final cnpjCpf = cpfCnpjLabel(currentData["ramo"]);

    cnpjFocus.addListener(() {
      if (!cnpjFocus.hasFocus) {
        _verifyCpfCnpj(cnpjCpf['controller'].text, cnpjCpf["ramo"]);

        completeCadastro(cnpjCpf['controller']);
      }
    });

    cepFocus.addListener(() async {
      if (!cepFocus.hasFocus) {
        await _authBloc.getEnderecoCep(_zipCodeController.text);
      }
    });

    atualizacaoEndereco = _authBloc.enderecoStream.listen((event) {
      if (!event.isEmpty) {
        setState(() {
          _ufController.text = event.endereco.uf;
          _codMunicipioController.text = event.endereco.ibge;
          _zipCodeController.text = event.endereco.cep;
          _addressController.text = event.endereco.logradouro;
          _districtController.text = event.endereco.bairro;
          _cityController.text = event.endereco.localidade;
        });
      }
    });
  }

  @override
  void dispose() {
    cepFocus.dispose();
    atualizacaoEndereco.cancel();
    cnpjFocus.dispose();
    otherFocus.dispose();
    _cnpjController.dispose();
    _cpfController.dispose();
    _nameController.dispose();
    _crmController.dispose();
    _emailFiscalController.dispose();
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
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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

              if (snapshot.data["activity"] == "Usuário de Lente Contato") {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Prezado Cliente",
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Sentimos muito, este aplicativo é voltado apenas para profissionais da área.",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "Por favor, converse com seu oftamologista ou clinica especializada para realizar um pedido para atender sua necessidade.",
                          style: Theme.of(context).textTheme.subtitle1),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Obrigado!",
                              style: Theme.of(context).textTheme.subtitle1),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  Text(
                    snapshot.data["activity"],
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
                    children: defineCadastralTerms(snapshot.data['ramo']).map(
                      (e) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFieldWidget(
                            textCapitalization: e['textCapitalization'],
                            focus: e['focus'],
                            labelText: e['labelText'],
                            prefixIcon: e['prefixIcon'],
                            controller: e['controller'],
                            validator: e['validator'],
                            keyboardType: e['keyboardType'],
                            enabled: e['enabled'],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Endereço',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    children: registerAddressTerms().map(
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
                            enabled: e['enabled'],
                            keyboardType: e['keyboardType'],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "Corrija os erros em vermelho antes de enviar.")));
                      } else {
                        _handleSubmit();
                      }
                    },
                    child: Text(
                      this.textRegister,
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
