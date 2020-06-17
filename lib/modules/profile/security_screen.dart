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
  TextEditingController _passwordController;
  List<Map> _data;

  _onShowPassword(bool value) {
    _profileWidgetBloc.securityShowPasswordIn.add(value);
  }

  _onSubmit() {}

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _data = [
      {
        'labelText': 'Digite uma senha',
        'controller': _passwordController,
      },
      {
        'labelText': 'Confirme a senha',
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
            'Crie e gerencie acessos diretos para seus colaboradores fazerem pedidos através da sua conta:',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _data.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return StreamBuilder<bool>(
                stream: _profileWidgetBloc.securityShowPasswordOut,
                builder: (context, snapshot) {
                  return TextFieldWidget(
                    obscureText: snapshot.data,
                    labelText: _data[index]['labelText'],
                    suffixIcon: IconButton(
                      onPressed: () => _onShowPassword(!snapshot.data),
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
                },
              );
            },
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _onSubmit,
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
