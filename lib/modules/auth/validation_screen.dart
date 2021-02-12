import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class ValidationScreen extends StatefulWidget {
  AuthEvent login;

  ValidationScreen({this.login});

  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  @override
  void initState() {
    _authBloc.clienteDataSink.add(widget.login);
    super.initState();
  }

  void _exitApp() async {
    await _authBloc.signOutOut.first;

    Modular.to.pushNamedAndRemoveUntil(
      '/auth/login',
      (route) => route.isFirst,
    );
  }

  Widget waitingScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Aguarde, estamos validando seu cadastro.",
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Theme.of(context).accentColor,
                  fontWeight:
                      FontWeight.lerp(FontWeight.w400, FontWeight.w800, 0.3)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Te enviamos um email para a verificação da sua conta e retornaremos assim que validarmos a sua conta. Para adiantar o seu processo, solicitamos que verifique o seu email.",
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: RaisedButton(
                  onPressed: _exitApp,
                  child: Text(
                    'Sair',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Validação de cadastro',
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: waitingScreen(),
    );
  }
}
