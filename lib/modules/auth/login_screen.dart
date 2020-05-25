import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;

  _handleLogin() async {
    Modular.to.pushNamed('/home/0');
  }

  _handlePasswordReset() {
    Modular.to.pushNamed('/auth/passwordReset');
  }

  _handleCreateAccount() {
    Modular.to.pushNamed('/auth/createAccount');
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
                ),
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: 'Senha',
                controller: _passwordController,
                prefixIcon: Icon(
                  Icons.lock,
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _handlePasswordReset,
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
                onPressed: _handleLogin,
                child: Text(
                  'Entrar',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                heightFactor: MediaQuery.of(context).size.height / 60,
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
                          ..onTap = _handleCreateAccount,
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
