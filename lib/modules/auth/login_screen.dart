import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _remember = false;
  String _emailStored = null;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _showErrors(Map<String, dynamic> errors) {
    SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
    _scaffoldKey.currentState.showSnackBar(
      _snack,
    );
  }

  _onLogin() async {
    if (_formKey.currentState.validate()) {
      _authBloc.loginIn.add({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      LoginEvent _login = await _authBloc.loginOut.first;

      if (!_login.isValid) {
        String _message = Helper.handleFirebaseError(
          _login.message,
        );

        SnackBar _snackBar = SnackBar(
          content: Text(_login.message),
        );

        _scaffoldKey.currentState.showSnackBar(
          _snackBar,
        );
      } else if (_login.result.user.isEmailVerified) {
        AuthEvent _cliente = await _authBloc.getCurrentUser(_login);
        if (_cliente.isValid) {
          if (!_cliente.data.cadastrado) {
            _authWidgetBloc.createAccountDataIn
                .add({'email': _cliente.data.email, 'ddd': '27'});
            Modular.to.pushNamed('/auth/activityPerformed');
          } else if (_cliente.isValid) {
            _authBloc.setLoginEvent(_login);
            final prefs = await _prefs;
            final int rememberStatus = prefs.getInt('rememberStatus');

            if (rememberStatus != null) {
              prefs.setString('emailStored', _emailController.text);
            } else {
              prefs.setString('emailStored', null);
            }

            Modular.to.pushNamedAndRemoveUntil(
              '/home/0',
              (route) => route.isFirst, //(Route<dynamic> route) => false
            );
          } else {
            Modular.to.pushNamed('/auth/validate');
          }
        } else {
          if (_cliente.integrated) {
            Modular.to.pushNamed('/auth/validate');
          }
          _showErrors(_cliente.errorData);
        }
      } else {
        try {
          await _login.result.user.sendEmailVerification();
          _showErrors({
            "Verificar email": ["Te enviamos um email de verificaçao"]
          });
        } catch (e) {}
      }
    }
  }

  _onPasswordReset() {
    Modular.to.pushNamed('/auth/passwordReset');
  }

  _onCreateAccount() {
    Modular.to.pushNamed('/auth/createAccount');
  }

  _onShowPassword() async {
    bool _first = await _authWidgetBloc.loginShowPasswordOut.first;

    _authWidgetBloc.loginShowPasswordIn.add(
      !_first,
    );
  }

  Future<bool> _rememberMe() async {
    final prefs = await _prefs;
    final int rememberStatus = prefs.getInt('rememberStatus');

    if (rememberStatus == null) {
      setState(() {
        _remember = true;
      });
      prefs.setInt('rememberStatus', 1);
      return true;
    }
    prefs.setInt('rememberStatus', null).then((bool success) {
      setState(() {
        _remember = false;
      });
    });

    return true;
  }

  Future<String> _getEmailStored() async {
    final prefs = await _prefs;
    if (prefs.getString('emailStored') != null) {
      final TextEditingController emailStored =
          TextEditingController(text: prefs.getString('emailStored'));
      setState(() {
        _emailController = emailStored;
        _remember = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _getEmailStored();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 90, bottom: 90),
                  child: Container(
                      height: 90,
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 4,
                        child: Image.asset(
                          'assets/images/logo_alinhada_2.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ))),
              TextFieldWidget(
                labelText: 'Email',
                controller: _emailController,
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xffA1A1A1),
                ),
                validator: Helper.emailValidator,
              ),
              SizedBox(height: 20),
              StreamBuilder<bool>(
                  stream: _authWidgetBloc.loginShowPasswordOut,
                  builder: (context, snapshot) {
                    return TextFieldWidget(
                      labelText: 'Senha',
                      controller: _passwordController,
                      obscureText: snapshot.hasData,
                      suffixIcon: IconButton(
                        onPressed: _onShowPassword,
                        icon: Icon(
                          snapshot.hasData
                              ? Icons.remove_red_eye
                              : MaterialCommunityIcons.eye_off,
                          color: Color(0xffA1A1A1),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color(0xffA1A1A1),
                      ),
                      validator: Helper.lengthValidator,
                    );
                  }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _remember,
                        onChanged: (bool value) => {_rememberMe()},
                      ),
                      Text("Lembrar Email")
                    ],
                  ),
                  GestureDetector(
                    onTap: _onPasswordReset,
                    child: Text(
                      'Esqueceu a senha?',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: Theme.of(context).accentColor,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: _onLogin,
                child: Text(
                  'Entrar',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                heightFactor: MediaQuery.of(context).size.height / 145,
                child: Text.rich(
                  TextSpan(
                    text: 'Não possui conta ainda? ',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Color(0xffA5A5A5),
                        ),
                    children: [
                      TextSpan(
                        text: 'Cadastre-se',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: Theme.of(context).accentColor,
                              decoration: TextDecoration.underline,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onCreateAccount,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
