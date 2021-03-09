import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  _showErrors(Map<String, dynamic> errors) {
    SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
    _scaffoldKey.currentState.showSnackBar(
      _snack,
    );
  }

  _sendResetEmail() async {
    ResetPassword _reset =
        await _authBloc.checkUserEmail(_emailController.text);
    if (_reset.canReset) {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      Dialogs.success(this.context,
          title: "Email enviado!",
          buttonText: "Voltar",
          subtitle: "Acesse seu email e atualize sua senha!", onTap: () {
        Modular.to.popUntil((route) => route.isFirst);
        Modular.to.pushReplacementNamed('/auth/login');
      });
    } else {
      _showErrors(_reset.errorData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recuperar Senha',
            textAlign: TextAlign.left,
          ),
          centerTitle: false,
        ),
        key: _scaffoldKey,
        body: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    "Insira seu email e nós enviaremos para voçê as instruções para mudar sua senha.",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    child: TextFieldWidget(
                      controller: _emailController,
                      prefixIcon: Icon(Icons.email, color: Color(0xffA1A1A1)),
                      labelText: "Email",
                    )),
                Container(
                  width: 150,
                  child: RaisedButton(
                    onPressed: _sendResetEmail,
                    child: Text(
                      'Enviar',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
