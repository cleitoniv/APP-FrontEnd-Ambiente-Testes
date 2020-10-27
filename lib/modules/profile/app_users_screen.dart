import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/usuario_cliente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class AppUsersScreen extends StatefulWidget {
  @override
  _AppUsersScreenState createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen> {
  UserBloc _userBloc = Modular.get<UserBloc>();

  _onAddUser() {
    Modular.to.pushNamed(
      '/profile/appUsers/add',
    );
  }

  _onEditUser(UsuarioClienteModel usuario) {
    Modular.to.pushNamed('/profile/appUsers/edit', arguments: usuario);
  }

  @override
  void initState() {
    _userBloc.fetchUsuariosCliente();
    super.initState();
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
            'Lista de Usuários',
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
          StreamBuilder(
            stream: _userBloc.usuariosClienteStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                    child: Text("Nao há usuarios cadastrados no momento."));
              }

              return ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data.usuarios.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _onEditUser(snapshot.data.usuarios[index]);
                    },
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xffF1F1F1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTileMoreCustomizable(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "${snapshot.data.usuarios[index].nome}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            subtitle: Text(
                              "${snapshot.data.usuarios[index].email}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontSize: 14,
                                    color: Colors.black38,
                                  ),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              size: 30,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        Positioned(
                          left: -10,
                          top: 20,
                          child: Icon(
                            Icons.check_circle,
                            color: Theme.of(context).accentColor,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 30),
          RaisedButton.icon(
            onPressed: _onAddUser,
            elevation: 0,
            color: Theme.of(context).primaryColor,
            icon: Icon(
              MaterialCommunityIcons.plus,
              color: Colors.white,
            ),
            label: Text(
              'Adicionar Outro Usuário',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
