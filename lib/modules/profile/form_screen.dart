import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/usuario_cliente.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class FormScreen extends StatefulWidget {
  final String formType;
  final UsuarioClienteModel usuario;

  FormScreen({this.formType = 'add', this.usuario});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProfileWidgetBloc _profileWidgetBloc = Modular.get<ProfileWidgetBloc>();
  UserBloc _userBloc = Modular.get<UserBloc>();
  AuthBloc _authBlock = Modular.get<AuthBloc>();
  List<Map> _data;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _officeController;
  MaskedTextController _passwordController;
  bool accept = false;
  bool isLoading = false;

  _onAddUser() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> params = {
      "nome": _nameController.text,
      "email": _emailController.text,
      "cargo": _officeController.text
    };

    AddUsuarioCliente addUser = await _userBloc.addUsuario(params);

    setState(() {
      isLoading = false;
    });
    _userBloc.fetchUsuariosCliente();

    if (addUser.isValid) {
      Modular.to.pop();
    } else {
      SnackBar _snackBar = SnackBar(
        content: Text(
          addUser.errorMessage,
        ),
      );

      _scaffoldKey.currentState.showSnackBar(_snackBar);
    }
  }

  _handleShowTerm() {
    Modular.to.pushNamed('/auth/terms');
  }

  _accepTermUser(bool value) {
    setState(() {
      accept = value;
    });
  }

  _onSaveInfo() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> params = {
      "nome": _nameController.text,
      "email": _emailController.text,
      "cargo": _officeController.text,
      "status": _profileWidgetBloc.currentStatus ? 1 : 0
    };

    UpdateUsuarioCliente updateUser =
        await _userBloc.updateUsuario(widget.usuario.id, params);

    setState(() {
      isLoading = false;
    });
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                "Sim",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: _onDeleteUser,
            ),
            SizedBox(height: 10),
            ElevatedButton(
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
    print("----");
    print(updateUser);
    if (updateUser.isValid) {
      _userBloc.fetchUsuariosCliente();
      Modular.to.pop();
    }
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

    _data = [
      {
        'labelText': 'Nome',
        'maxLength': 15,
        'maxLengthEnforce': MaxLengthEnforcement.enforced,
        'capitalization': TextCapitalization.words,
        'controller': _nameController,
        'icon': Icons.person,
        'enabled': true,
        'validator': (String text) => Helper.lengthValidator(text)
      },
      {
        'labelText': 'Email',
        'controller': _emailController,
        'icon': Icons.email,
        'enabled': widget.formType == "edit" ? false : true,
        'validator': (String text) => Helper.emailValidator(text)
      },
      {
        'labelText': 'Cargo (opcional)',
        'controller': _officeController,
        'capitalization': TextCapitalization.words,
        'icon': Icons.assignment,
        'enabled': true,
        'validator': null
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
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Usuários do Aplicativo'),
          centerTitle: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              widget.formType == 'edit'
                  ? 'Editar Usuário'
                  : 'Cadastrar Usuário',
              style: Theme.of(context).textTheme.headline5,
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
                  return TextFieldWidget(
                    maxLength: _data[index]['maxLength'],
                    maxLengthEnforce: _data[index]['maxLengthEnforce'],
                    textCapitalization: _data[index]['capitalization'],
                    enabled: _data[index]['enabled'],
                    validator: _data[index]["validator"],
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
            widget.formType == "edit"
                ? Container()
                : Row(children: <Widget>[
                    Checkbox(
                      value: accept,
                      onChanged: _accepTermUser,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Aceito os ',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                            ),
                        children: [
                          TextSpan(
                            text: 'Termos de responsabilidade',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Theme.of(context).accentColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _handleShowTerm,
                          ),
                        ],
                      ),
                    ),
                  ]),
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
            _authBlock.getAuthCurrentUser.data.role == 'CLIENTE' &&
                    widget.formType == "edit"
                ? isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: accept
                            ? null
                            : widget.formType == 'edit'
                                ? _onSaveInfo
                                : _onAddUser,
                        child: Text(
                          widget.formType == 'edit'
                              ? 'Salvar Alterações de Usuário'
                              : 'Cadastrar Novo Usuário',
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        onPressed: !accept
                            ? null
                            : widget.formType == 'edit'
                                ? _onSaveInfo
                                : _onAddUser,
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
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, elevation: 0),
                        onPressed: _showDialog,
                        child: Text(
                          'Excluir Usuário',
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                    : Container()
                : Container()
          ],
        ),
      ),
    );
  }
}
