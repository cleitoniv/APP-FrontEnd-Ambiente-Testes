import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RequestInfoScreen extends StatelessWidget {
  int id;

  RequestInfoScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do pedido'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          Text(
            'Informações do Pedido',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: [
                  Text(
                    'Pedido nº',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Último Pedido',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              TableRow(
                children: [
                  Text(
                    '123456',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '30/02/2019',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Produtos Comprados',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            padding: const EdgeInsets.all(20),
            color: Color(0xffF1F1F1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Paciente',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Nº de Ref.',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Nascimento',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          'Marta Almeida',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '24545',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '03/05/1966',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 10,
                  leading: CachedNetworkImage(
                    imageUrl:
                        'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    'Bioview Asferica Cx 6',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Qnt. 2',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                      ),
                      SizedBox(width: 20),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xff707070),
                        child: Icon(
                          Icons.attach_money,
                          color: Color(0xffF1F1F1),
                          size: 15,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Avulso',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    'R\$ ${Helper.intToMoney(20000)}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
                SizedBox(height: 10),
                ListTileMoreCustomizable(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  leading: Image.asset(
                    'assets/icons/info.png',
                    width: 25,
                    height: 25,
                  ),
                  title: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Quantidade selecionada tem duração recomendada de ',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        TextSpan(
                          text: '1 ano.',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 50,
                  thickness: 0.3,
                  color: Colors.black38,
                ),
                Text(
                  'Parâmetros',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Olho esquerdo',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        Text(
                          'Olho direito',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
