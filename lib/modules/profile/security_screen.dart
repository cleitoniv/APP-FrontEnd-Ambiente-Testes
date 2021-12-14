import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SecurityScreen extends StatefulWidget {
  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  ProfileWidgetBloc _profileWidgetBloc = Modular.get<ProfileWidgetBloc>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  TextEditingController _passwordController;
  List<Map> _data;
  bool _passwordObscure = true;
  bool _passwordConfirmObscure = true;
  bool _lock = false;

  _onShowPasswordType(String type) {
    if (type == 'senha') {
      setState(() {
        this._passwordObscure = !this._passwordObscure;
      });
    } else {
      setState(() {
        this._passwordConfirmObscure = !this._passwordConfirmObscure;
      });
    }
  }

  _onSubmit() async {
    setState(() {
      _lock = true;
    });
    if (_formKey.currentState.validate()) {
      _authBloc.updatePasswordIn.add(
        _passwordController.text,
      );

      String _data = await _authBloc.updatePasswordOut.first;
      String _message = '';

      setState(() {
        _lock = false;
      });

      if (_data.contains('ERROR')) {
        _message = Helper.handleFirebaseError(
          _data,
        );
      } else {
        _message = 'Senha alterada com sucesso';
        Timer(Duration(seconds: 2), () {
          Modular.to.pop();
        });
      }

      SnackBar _snackBar = SnackBar(
        content: Text(_message),
      );

      _scaffoldKey.currentState.showSnackBar(
        _snackBar,
      );
    }

    setState(() {
      _lock = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _data = [
      {
        'labelText': 'Digite uma senha',
        'type': 'senha',
        'controller': _passwordController,
        'validator': (String text) => Helper.passwordValidator(
              text,
              length: 6,
            )
      },
      {
        'labelText': 'Confirme a senha',
        'type': 'confirm',
        'validator': (String text) => Helper.equalValidator(
              text,
              value: _passwordController.text,
              message: 'As senhas não coincidem',
            )
      },
    ];
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Segurança'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Alterar sua senha',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Para alterar sua senha, digite a nova senha e confirme.',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: _data.length,
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                itemBuilder: (context, index) {
                  return StreamBuilder<bool>(
                    stream: _profileWidgetBloc.securityShowPasswordOut,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (_data[index]['type'] == 'senha') {
                        return TextFieldWidget(
                          obscureText: _passwordObscure,
                          labelText: _data[index]['labelText'],
                          suffixIcon: IconButton(
                            onPressed: () =>
                                _onShowPasswordType(_data[index]['type']),
                            icon: Icon(
                              snapshot.data
                                  ? MaterialCommunityIcons.eye
                                  : MaterialCommunityIcons.eye_off,
                              color: Color(0xffa1a1a1),
                            ),
                          ),
                          prefixIcon: Icon(
                            MaterialCommunityIcons.lock,
                            color: Color(0xffA1A1A1),
                          ),
                          controller: _data[index]['controller'],
                          validator: _data[index]['validator'],
                        );
                      } else {
                        return TextFieldWidget(
                          obscureText: _passwordConfirmObscure,
                          labelText: _data[index]['labelText'],
                          suffixIcon: IconButton(
                            onPressed: () =>
                                _onShowPasswordType(_data[index]['type']),
                            icon: Icon(
                              snapshot.data
                                  ? MaterialCommunityIcons.eye
                                  : MaterialCommunityIcons.eye_off,
                              color: Color(0xffa1a1a1),
                            ),
                          ),
                          prefixIcon: Icon(
                            MaterialCommunityIcons.lock,
                            color: Color(0xffA1A1A1),
                          ),
                          controller: _data[index]['controller'],
                          validator: _data[index]['validator'],
                        );
                      }
                    },
                  );
                }),
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _lock ? null : () => _onSubmit(),
            child: Text(
              'Alterar Senha',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
