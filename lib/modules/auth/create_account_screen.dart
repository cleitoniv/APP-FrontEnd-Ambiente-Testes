import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _emailPromoController;
  MaskedTextController _phoneController;
  TextEditingController _passwordController;
  List<Map> _fieldData;

  _handleObscureText() async {
    bool _first = await _authWidgetBloc.createAccountShowPasswordOut.first;

    _authWidgetBloc.createAccountShowPasswordIn.add(
      !_first,
    );
  }

  _handleShowTerm() {}

  _showErrors(Map<String, dynamic> errors) {
    SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
    _scaffoldKey.currentState.showSnackBar(
      _snack,
    );
  }

  _handleSubmit() async {
    if (_formKey.currentState.validate()) {
      final Map<String, dynamic> data = {
        'name': _nameController.text,
        'email': _emailController.text,
        'email_fiscal': _emailPromoController.text,
        'telefone': _phoneController.text,
        'ddd': '27',
        'password': _passwordController.text,
      };
      final String authResult = await _authWidgetBloc.registerGuestToken(data);
      if (authResult == "ok") {
        LoginEvent firstAccess =
            await _authBloc.firstAccess({'nome': data['name'], ...data});
        if (firstAccess.isValid) {
          Modular.to
              .pushNamed('/auth/confirmSms', arguments: _phoneController.text);
          // Modular.to.pushNamed('/auth/activityPerformed');
        } else {
          _showErrors({
            "Cadastro": [
              "Ocorreu um erro no seu cadastro. Por favor entre em contato com a Central."
            ]
          });
        }
      } else {
        final errors = {
          "ERROR_WEAK_PASSWORD": {
            "Senha": ["Senha deve conter no minimo 6 caracteres."]
          },
          "ERROR_EMAIL_ALREADY_IN_USE": {
            "Email": [
              "Email ja cadastrado. Faça o login e atualize os seus dados."
            ]
          }
        };

        _showErrors(errors[authResult]);
      }
    }
  }

  _handleAcceptTerm(bool value) {
    _authWidgetBloc.createAccountTermIn.add(
      value,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _emailPromoController = TextEditingController();
    _phoneController = MaskedTextController(
      mask: '00 00000-0000',
    );
    _passwordController = TextEditingController();

    _fieldData = [
      {
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
        'labelText': 'Email de Acesso',
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
        'labelText': 'Email para info. Fiscais',
        'prefixIcon': Icon(
          Icons.email,
          color: Color(0xffA1A1A1),
        ),
        'suffixIcon': null,
        'controller': _emailPromoController,
        'validator': Helper.emailValidator,
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
        'validator': (String text) => Helper.lengthValidator(
              text,
              length: 13,
              message: 'Celular deve possuir 11 dígitos',
            ),
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Digite uma senha',
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
        'validator': (String text) => Helper.lengthValidator(text,
            length: 6, message: "Senha deve ter no minimo 6 caracteres"),
      },
      {
        'labelText': 'Confirme a senha',
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
        'controller': null,
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
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: StreamBuilder<bool>(
                        stream: _authWidgetBloc.createAccountShowPasswordOut,
                        builder: (context, snapshot) {
                          return TextFieldWidget(
                            labelText: e['labelText'],
                            prefixIcon: e['prefixIcon'],
                            controller: e['controller'],
                            suffixIcon: e['suffixIcon'],
                            validator: e['validator'],
                            keyboardType: e['keyboardType'],
                            obscureText: snapshot.data,
                          );
                        },
                      ),
                    );
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
                        value: snapshot.hasData ? snapshot.data : false,
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
              RaisedButton(
                onPressed: _handleSubmit,
                child: Text(
                  'Cadastrar',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
