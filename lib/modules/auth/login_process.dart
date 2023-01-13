import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginProcessScreen extends StatefulWidget {
  final AuthEvent login;

  LoginProcessScreen({this.login});

  @override
  _LoginProcessScreenState createState() => _LoginProcessScreenState();
}

class _LoginProcessScreenState extends State<LoginProcessScreen> {
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
              "Aguarde, estamos validando seu cadastro na Central Oftalmica.",
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: Theme.of(context).accentColor,
                  fontWeight:
                      FontWeight.lerp(FontWeight.w400, FontWeight.w800, 0.3)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: ElevatedButton(
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Validação de cadastro',
            textAlign: TextAlign.left,
          ),
          leading: Container(),
          centerTitle: false,
        ),
        body: waitingScreen(),
      ),
    );
  }
}
