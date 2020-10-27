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
              "Aguarde...",
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Theme.of(context).accentColor,
                  fontWeight:
                      FontWeight.lerp(FontWeight.w500, FontWeight.w800, 0.3)),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "Estamos validando seu cadastro",
            style: TextStyle(
              fontSize: 20,
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
