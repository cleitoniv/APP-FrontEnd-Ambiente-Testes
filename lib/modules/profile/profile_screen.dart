import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProfileScreen extends StatelessWidget {
  final List<Map> _data = [
    {
      'title': 'Informações Pessoais',
      'subtitle': 'Informações básicas',
      'route': '/profile/personalInfo',
    },
    {
      'title': 'Endereço de Entrega',
      'subtitle': 'Dados para entrega dos produtos',
      'route': '/profile/deliveryAddress',
    },
    {
      'title': 'Segurança',
      'subtitle': 'Altere sua senha de acesso',
      'route': '/profile/security',
    },
    {
      'title': 'Usuários do Aplicativo',
      'subtitle': 'Crie e gerencie usuários da sua conta',
      'route': '/profile/appUsers',
    },
  ];

  _handleTap(String route) {
    Modular.to.pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Perfil'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _data.length,
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        itemBuilder: (context, index) {
          return ListTileMoreCustomizable(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0,
            onTap: (value) => _handleTap(
              _data[index]['route'],
            ),
            leading: Image.asset(
              'assets/icons/profile_$index.png',
              width: 25,
              height: 25,
            ),
            title: Text(
              _data[index]['title'],
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              _data[index]['subtitle'],
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
            ),
          );
        },
      ),
    );
  }
}
