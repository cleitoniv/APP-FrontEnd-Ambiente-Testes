import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/usuario_cliente.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class FormScreen extends StatefulWidget {
  //add or edit
  String formType;
  UsuarioClienteModel usuario;

  FormScreen({this.formType = 'add', this.usuario});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProfileWidgetBloc _profileWidgetBloc = Modular.get<ProfileWidgetBloc>();
  UserBloc _userBloc = Modular.get<UserBloc>();
  AuthBloc _authBlock = Modular.get<AuthBloc>();
  List<Map> _data;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _officeController;
  MaskedTextController _passwordController;

  _onAddUser() async {
    Map<String, dynamic> params = {
      "nome": _nameController.text,
      "email": _emailController.text,
      "cargo": _officeController.text
    };
    AddUsuarioCliente addUser = await _userBloc.addUsuario(params);
    _userBloc.fetchUsuariosCliente();
    if (addUser.isValid) {
      Modular.to.pop();
    } else {
      print(addUser.errorMessage);
      SnackBar _snackBar = SnackBar(
        content: Text(
          addUser.errorMessage,
        ),
      );

      _scaffoldKey.currentState.showSnackBar(_snackBar);
    }
  }

  _onSaveInfo() async {
    Map<String, dynamic> params = {
      "nome": _nameController.text,
      "email": _emailController.text,
      "cargo": _officeController.text,
      "status": _profileWidgetBloc.currentStatus ? 1 : 0
    };

    UpdateUsuarioCliente updateUser =
        await _userBloc.updateUsuario(widget.usuario.id, params);
    if (updateUser.isValid) {
      _userBloc.fetchUsuariosCliente();
      Modular.to.pop();
    }
  }

  _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Remoção de Usuário",
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text("Essa ação não pode ser desfeita! Continuar?"),
          actions: [
            RaisedButton(
              color: Colors.red,
              child: Text(
                "Sim",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _onDeleteUser,
            ),
            RaisedButton(
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Modular.to.pop();
                })
          ],
        );
      },
    );
  }

  _onDeleteUser() async {
    Modular.to.pop();
    DeleteUsuarioCliente updateUser =
        await _userBloc.deleteUsuarioCliente(widget.usuario.id);
    if (updateUser.isValid) {
      _userBloc.fetchUsuariosCliente();
      Modular.to.pop();
    }
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

    if (widget.usuario != null) {
      _nameController.text = widget.usuario.nome;
      _emailController.text = widget.usuario.email;
      _officeController.text = widget.usuario.cargo;
    }

    print(_authBlock.getAuthCurrentUser.data.role);

    _data = [
      {
        'labelText': 'Nome completo',
        'controller': _nameController,
        'icon': Icons.person,
        'enabled': true,
      },
      {
        'labelText': 'Email',
        'controller': _emailController,
        'icon': Icons.email,
        'enabled': widget.formType == "edit" ? false : true,
      },
      {
        'labelText': 'Cargo (opcional)',
        'controller': _officeController,
        'icon': MaterialCommunityIcons.cake_layered,
        'enabled': true,
      }
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
      key: _scaffoldKey,
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
          // widget.formType == 'edit'
          //     ? ListTileMoreCustomizable(
          //         dense: true,
          //         contentPadding: const EdgeInsets.all(0),
          //         horizontalTitleGap: 0,
          //         title: Text(
          //           'Ativar/Desativar Usuário',
          //           style: Theme.of(context).textTheme.subtitle1.copyWith(
          //                 fontSize: 14,
          //               ),
          //         ),
          //         trailing: StreamBuilder<bool>(
          //           stream: _profileWidgetBloc.userStatusOut,
          //           builder: (context, snapshot) {
          //             if (_authBlock.getAuthCurrentUser.data.role ==
          //                 'CLIENTE') {
          //               if (snapshot.hasData) {
          //                 return Switch(
          //                   value: snapshot.data,
          //                   activeColor: Theme.of(context).primaryColor,
          //                   onChanged: (value) => _onChangeUserStatus(value),
          //                 );
          //               } else {
          //                 return Switch(
          //                   value: false,
          //                   activeColor: Theme.of(context).primaryColor,
          //                   onChanged: (value) => _onChangeUserStatus(value),
          //                 );
          //               }
          //             }
          //             return Container();
          //           },
          //         ),
          //       ):
          Container(),
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
          SizedBox(height: 30),
          _authBlock.getAuthCurrentUser.data.role == 'CLIENTE'
              ? widget.formType == 'edit'
                  ? RaisedButton(
                      color: Colors.red,
                      onPressed: _showDialog,
                      elevation: 0,
                      child: Text(
                        'Excluir Usuário',
                        style: Theme.of(context).textTheme.button,
                      ),
                    )
                  : Container()
              : Container()
        ],
      ),
    );
  }
}
