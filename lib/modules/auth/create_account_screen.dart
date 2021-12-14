import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String _requestCodeController;
  TextEditingController _confirmSms;

  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController;
  TextEditingController _emailController;
  MaskedTextController _phoneController;
  TextEditingController _passwordController;
  TextEditingController _passwordConfirmController;
  TextEditingController _nicknameController;
  bool _passwordObscure = true;
  bool _passwordConfirmObscure = true;
  bool _isLoading = false;
  List<Map> _fieldData;
  bool _lock = true;

  _handleObscureText() async {
    setState(() {
      this._passwordObscure = !this._passwordObscure;
    });
  }

  _handleConfirmObscureText() async {
    setState(() {
      this._passwordConfirmObscure = !this._passwordConfirmObscure;
    });
  }

  _handleShowTerm() {
    Modular.to.pushNamed('/auth/terms');
  }

  _showErrors(Map<String, dynamic> errors) {
    SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
    _scaffoldKey.currentState.showSnackBar(
      _snack,
    );
  }

  _handleConfirmSms() async {
    if (_confirmSms.text.trim().length == 0) {
      _showDialog("Atenção", "Preencha o campo código!");
      return;
    }

    String phonex = _phoneController.text.replaceAll('-', '');
    phonex = phonex.replaceAll(' ', '');
    // phonex = "${ddd + phonex}";
    bool codeMatch = await _authWidgetBloc.confirmSms(
        int.parse(_confirmSms.text), int.parse(phonex));

    if (codeMatch) {
      await _handleSubmit();
      // Modular.to.pushNamed('/auth/activityPerformed');
    } else {
      _showDialog("Atenção", "Código Inválido ou expirado!");
    }
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
            RaisedButton(
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

  _confirmSmsDialog() async {
    setState(() {
      _lock = false;
      _requestCodeController = "Aguarde 30 seg...";
      _confirmSms.text = '';
    });

    if (_formKey.currentState.validate()) {
      String phonex = _phoneController.text.replaceAll('-', '');
      phonex = phonex.replaceAll(' ', '');
      var codeGenerated =
          await _authWidgetBloc.requireCodeSms(int.parse(phonex));

      if (!codeGenerated["success"]) {
        _showDialog("Atenção", codeGenerated["data"]);
        return;
      }

      Timer(Duration(seconds: 10), () {
        setState(() {
          _lock = true;
          _requestCodeController = "Cadastrar";
        });
      });
      //_endLoad();
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 120,
                  child: Column(
                    children: [
                      Text(
                          "Digite o Código que Enviamos ao Celular Informado!"),
                      new Expanded(
                        child: new TextField(
                          controller: _confirmSms,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              labelText: _phoneController.text,
                              hintText: '* * * *'),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('EDITAR TELEFONE'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('CONFIRMAR'), onPressed: _handleConfirmSms)
          ],
        ),
      );
    }
  }

  _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      final Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'apelido': _nicknameController.text,
        'telefone': _phoneController.text,
        'ddd': '27',
        'password': _passwordController.text,
      };
      final String authResult = await _authWidgetBloc.registerGuestToken(data);
      print(authResult);
      if (authResult == "ok") {
        LoginEvent firstAccess =
            await _authBloc.firstAccess({'nome': data['name'], ...data});
        if (!firstAccess.isValid && firstAccess.errorData["TELEFONE"] != '') {
          _showErrors({
            "Telefone": ["Esse número de telefone já está cadastrado."]
          });
        } else if (firstAccess.isValid) {
          Modular.to.pushNamed('/auth/activityPerformed');
        } else {
          _showErrors({
            "Cadastro": [
              "Ocorreu um erro no seu cadastro. Por favor entre em contato com a Central."
            ]
          });
        }
      } else {
        print("aqui");
        final errors = {
          "WEAK-PASSWORD": {
            "Senha": ["Senha deve conter no minimo 6 caracteres."]
          },
          "EMAIL-ALREADY-IN-USE": {
            "Email": [
              "Email ja cadastrado. Faça o login e atualize os seus dados."
            ]
          }
        };

        _showErrors(errors[authResult]);
        Modular.to.pop();
      }
    }
  }

  _handleAcceptTerm(bool value) {
    _authBloc.acceptTerm();
    setState(() {
      _lock = _authBloc.acceptTermGetter();
    });

    _authWidgetBloc.createAccountTermIn.add(
      value,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _confirmSms = TextEditingController();

    _phoneController = MaskedTextController(
      mask: '00 90000-0000',
    );
    _passwordController = TextEditingController();
    _nicknameController = TextEditingController();
    _requestCodeController = "Cadastrar";

    _fieldData = [
      {
        'textCapitalization': TextCapitalization.words,
        'labelText': 'Nome completo',
        'prefixIcon': Icon(
          Icons.person,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _nameController,
        'validator': Helper.lengthValidator,
      },
      {
        'textCapitalization': TextCapitalization.words,
        'maxLength': 15,
        'maxLengthEnforce': true,
        'labelText': 'Como gostaria de ser chamado?',
        'prefixIcon': Icon(
          Icons.person,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _nicknameController,
        'validator': Helper.lengthValidator,
      },
      {
        'labelText': 'Email de acesso',
        'prefixIcon': Icon(
          Icons.email,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _emailController,
        'validator': Helper.emailValidator,
        'keyboardType': TextInputType.emailAddress,
      },
      {
        'labelText': 'Confirme o email',
        'prefixIcon': Icon(
          Icons.email,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': null,
        'validator': (String text) => Helper.equalValidator(
              text,
              value: _emailController.text,
            ),
        'keyboardType': TextInputType.emailAddress,
      },
      {
        'labelText': 'Celular',
        'prefixIcon': Icon(
          MaterialCommunityIcons.cellphone,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _phoneController,
        'validator': (String text) => Helper.lengthValidatorDdd(
              text,
              length: 13,
              message: 'Celular deve possuir 11 dígitos',
            ),
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Digite uma senha',
        'type': 'password',
        'obscureText': this._passwordObscure,
        'prefixIcon': Icon(
          MaterialCommunityIcons.lock,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': IconButton(
          icon: Icon(
            MaterialCommunityIcons.eye,
            color: Color(0xffA1A1A1),
          ),
          onPressed: _handleObscureText,
        ),
        'controller': _passwordController,
        'validator': (String text) => Helper.passwordValidator(text, length: 6)
        // 'validator': (String text) => Helper.lengthValidator(text,
        //     length: 6, message: "Senha deve ter no minimo 6 caracteres"),
      },
      {
        'labelText': 'Confirme a senha',
        'type': 'confirm',
        'obscureText': this._passwordConfirmObscure,
        'prefixIcon': Icon(
          MaterialCommunityIcons.lock,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': IconButton(
          icon: Icon(
            MaterialCommunityIcons.eye,
            color: Color(0xffA1A1A1),
          ),
          onPressed: _handleConfirmObscureText,
        ),
        'controller': _passwordConfirmController,
        'validator': (String text) => Helper.equalValidator(
              text,
              value: _passwordController.text,
            ),
      },
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Cadastre-se',
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text(
                'Seja bem-vindo!',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Preencha os campos abaixo para criar sua conta em nosso aplicativo!',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              Column(
                children: _fieldData.take(5).map(
                  (e) {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextFieldWidget(
                        maxLength: e['maxLength'],
                        maxLengthEnforce: e['maxLengthEnforce'],
                        textCapitalization: e['textCapitalization'],
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
                'Escolha sua senha',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Column(
                children: _fieldData.skip(5).map(
                  (e) {
                    if (e['type'] == 'confirm') {
                      return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFieldWidget(
                            labelText: e['labelText'],
                            prefixIcon: e['prefixIcon'],
                            controller: e['controller'],
                            suffixIcon: e['suffixIcon'],
                            validator: e['validator'],
                            keyboardType: e['keyboardType'],
                            obscureText: this._passwordConfirmObscure,
                          ));
                    } else {
                      return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: TextFieldWidget(
                              labelText: e['labelText'],
                              prefixIcon: e['prefixIcon'],
                              controller: e['controller'],
                              suffixIcon: e['suffixIcon'],
                              validator: e['validator'],
                              keyboardType: e['keyboardType'],
                              obscureText: this._passwordObscure));
                    }
                  },
                ).toList(),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  StreamBuilder<bool>(
                    stream: _authWidgetBloc.createAccountTermOut,
                    builder: (context, snapshot) {
                      return Checkbox(
                        value:
                            _lock, // snapshot.hasData ? snapshot.data : false,
                        onChanged: _handleAcceptTerm,
                      );
                    },
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Aceito os ',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                          ),
                      children: [
                        TextSpan(
                          text: 'Termos de responsabilidade',
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: Theme.of(context).accentColor,
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _handleShowTerm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              !this._isLoading
                  ? RaisedButton(
                      onPressed:
                          !_lock ? null : _confirmSmsDialog, //  _handleSubmit,
                      child: Text(
                        _requestCodeController,
                        style: Theme.of(context).textTheme.button,
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
