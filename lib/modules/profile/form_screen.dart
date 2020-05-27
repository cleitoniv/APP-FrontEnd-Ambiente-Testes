import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class FormScreen extends StatefulWidget {
  //add or edit
  String formType;

  FormScreen({
    this.formType = 'add',
  });

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  ProfileWidgetBloc _profileWidgetBloc = Modular.get<ProfileWidgetBloc>();
  List<Map> _data;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _officeController;
  MaskedTextController _passwordController;

  _onAddUser() {
    Modular.to.pop();
  }

  _onSaveInfo() {
    Modular.to.pop();
  }

  _onChangeUserStatus(bool value) {
    _profileWidgetBloc.userStatusIn.add(value);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _officeController = TextEditingController();
    _passwordController = MaskedTextController(
      mask: '* * * * * * * *',
    );

    _data = [
      {
        'labelText': 'Nome completo',
        'value': '',
        'controller': _nameController,
        'icon': Icons.person,
        'enabled': true,
      },
      {
        'labelText': 'Email',
        'value': '',
        'controller': _emailController,
        'icon': Icons.email,
        'enabled': true,
      },
      {
        'labelText': 'Cargo (opcional)',
        'value': '',
        'controller': _officeController,
        'icon': MaterialCommunityIcons.cake_layered,
        'enabled': true,
      },
      {
        'labelText': 'Senha de acesso',
        'value': 'MT132546',
        'controller': _passwordController,
        'icon': Icons.lock,
        'enabled': false,
      },
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _officeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários do Aplicativo'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            widget.formType == 'edit' ? 'Editar Usuário' : 'Cadastrar Usuário',
            style: Theme.of(context).textTheme.headline5,
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
              return TextFieldWidget(
                enabled: _data[index]['enabled'],
                labelText: _data[index]['labelText'],
                prefixIcon: Icon(
                  _data[index]['icon'],
                  color: Color(0xffA1A1A1),
                ),
                controller: _data[index]['controller']
                  ..text = _data[index]['value'],
              );
            },
          ),
          ListTileMoreCustomizable(
            dense: true,
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0,
            leading: Image.asset(
              'assets/icons/info.png',
              width: 25,
              height: 25,
            ),
            title: Text(
              'Senha gerada automaticamente.',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
            ),
          ),
          widget.formType == 'edit'
              ? ListTileMoreCustomizable(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Ativar/Desativar Usuário',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  trailing: StreamBuilder<bool>(
                    stream: _profileWidgetBloc.userStatusOut,
                    builder: (context, snapshot) {
                      return Switch(
                        value: snapshot.data,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (value) => _onChangeUserStatus(value),
                      );
                    },
                  ),
                )
              : Container(),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: widget.formType == 'edit' ? _onSaveInfo : _onAddUser,
            elevation: 0,
            child: Text(
              widget.formType == 'edit'
                  ? 'Salvar Alterações de Usuário'
                  : 'Cadastrar Novo Usuário',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
