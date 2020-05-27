import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProfileScreen extends StatelessWidget {
  List<Map> _data = [
    {
      'title': 'Informações Pessoais',
      'subtitle': 'Informações básicas',
    },
    {
      'title': 'Endereço de Entrega',
      'subtitle': 'Dados para entrega dos produtos',
    },
    {
      'title': 'Segurança',
      'subtitle': 'Altere sua senha de acesso',
    },
    {
      'title': 'Usuários do Aplicativo',
      'subtitle': 'Crie e gerencie usuários a sua conta',
    },
  ];

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
