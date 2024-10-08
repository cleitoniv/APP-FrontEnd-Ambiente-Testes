import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Future<void> _launchURL(String url) async {
    bool _canLaunch = await canLaunch(url);

    if (_canLaunch) {
      await launch(url);
    }
  }

  _openTicket() {
    Modular.to.pushNamed(
      '/ticket',
    );
  }

  List<Map> _data;

  @override
  void initState() {
    _data = [
      {
        'title': 'www.centraloftalmica.com.br',
        'icon': 'clip.png',
        'onTap': () => _launchURL('https://www.centraloftalmica.com.br'),
      },
      {
        'title': 'contato@centraloftalmica.com',
        'icon': 'email.png',
        'onTap': () async {
          final Uri params = Uri(
            scheme: 'mailto',
            path: 'contato@centraloftalmica.com',
          );

          await _launchURL(params.toString());
        },
      },
      {'title': 'Termos de Uso', 'icon': 'security.png', 'onTap': () => false}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajuda'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Image.asset(
            'assets/images/logo_alinhada.png',
            width: MediaQuery.of(context).size.width / 2,
            height: 50,
          ),
          SizedBox(height: 30),
          Text(
            'Dúvidas, críticas e sugestões',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Caso tenha qualquer dúvida, crítica, sugestão utilize as opções abaixo para entrar em contato conosco, estamos a disposição para ajudá-lo!',
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
              return ListTileMoreCustomizable(
                onTap: (_) => _data[index]['onTap'](),
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 0,
                leading: Image.asset(
                  'assets/icons/${_data[index]['icon']}',
                  width: 25,
                  height: 25,
                ),
                title: Text(
                  _data[index]['title'],
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
          ),
          Container(
              child: ElevatedButton(
            onPressed: () => _openTicket(),
            child: Text(
              'Abrir um ticket',
              style: Theme.of(context).textTheme.button,
            ),
          ))
        ],
      ),
    );
  }
}
