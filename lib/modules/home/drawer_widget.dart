import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class DrawerWidget extends StatelessWidget {
  final List<Map> _data = [
    {
      'title': 'Meu Perfil',
      'image': 'drawer_0.png',
    },
    {'title': 'Meus Pedidos', 'image': 'drawer_1.png'},
    // {
    //   'title': 'Créditos',
    //   'image': 'drawer_2.png',
    //   'is_icon': true,
    //   'icon': Icons.add
    // },
    {
      'title': 'Notificações',
      'image': 'drawer_3.png',
    },
    //app capado descomentar as opções abaixo para retornar para aba de opções
    {
      'title': 'Devolução para Crédito/Troca',
      'image': 'drawer_4.png',
    },
    {
      'title': 'Meus Pontos',
      'image': 'drawer_5.png',
    },
    {
      'title': 'Pagamentos',
      'image': 'drawer_6.png',
    },
    {
      'title': 'Meus Créditos',
      'image': 'drawer_7.png',
    },
    // {
    //   'title': 'Meus Pacientes',
    //   'image': 'drawer_2.png',
    //   'is_icon': true,
    //   'icon': Icons.group
    // },
    {
      'title': 'Ajuda',
      'image': 'drawer_8.png',
    },
    {
      'title': 'Sair',
      'image': 'drawer_9.png',
    },
  ];

  final Function onClose;
  final Function(int) onNavigate;
  final Function onExitApp;

  DrawerWidget({
    this.onClose,
    this.onNavigate,
    this.onExitApp,
  });

  _handleTap(int index) {
    if (index <= 7) {
      onNavigate(index);
    } else {
      onExitApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_alinhada.png',
                  height: 40,
                ),
                IconButton(
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close,
                    size: 35,
                    color: Color(0xff707070),
                  ),
                ),
              ],
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
                bool isIcon = _data[index]['is_icon'] ?? false;
                if (!isIcon) {
                  return ListTileMoreCustomizable(
                    onTap: (value) => _handleTap(index),
                    contentPadding: const EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    leading: Image.asset(
                      'assets/icons/${_data[index]['image']}',
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      _data[index]['title'],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                } else {
                  return ListTileMoreCustomizable(
                    onTap: (value) => _handleTap(index),
                    contentPadding: const EdgeInsets.all(0),
                    horizontalTitleGap: 0,
                    leading: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [Color(0xFF30a2cf), Color(0XFF08e9cf)],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Icon(
                        _data[index]['icon'],
                        size: 35,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    title: Text(
                      _data[index]['title'],
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
