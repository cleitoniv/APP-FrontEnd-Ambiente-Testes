import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  bool _obscureText = true;

  _onLogin() async {
    if (_formKey.currentState.validate()) {
      _authBloc.loginIn.add({
        'email': _emailController.text,
        'password': _passwordController.text,
      });

      String _first = await _authBloc.loginOut.first;
      if (_first.contains('ERROR')) {
        String _message = Helper.handleFirebaseError(
          _first,
        );

        SnackBar _snackBar = SnackBar(
          content: Text(_message),
        );

        _scaffoldKey.currentState.showSnackBar(
          _snackBar,
        );
      } else {
        Modular.to.pushNamedAndRemoveUntil(
          '/home/0',
          (route) => route.isFirst,
        );
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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
              Align(
                alignment: Alignment.center,
                heightFactor: 4,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
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
                      obscureText: snapshot.data,
                      suffixIcon: IconButton(
                        onPressed: _onShowPassword,
                        icon: Icon(
                          snapshot.data
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
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _onPasswordReset,
                  child: Text(
                    'Esqueceu a senha?',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: Theme.of(context).accentColor,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
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
                heightFactor: MediaQuery.of(context).size.height / 75,
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
