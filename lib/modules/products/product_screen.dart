import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductScreen extends StatelessWidget {
  int id;

  ProductScreen({
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Produto'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          ListTileMoreCustomizable(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0,
            title: Text(
              'Bioview Asferica Cx 6',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 18,
                  ),
            ),
            trailing: Column(
              children: <Widget>[
                Text(
                  'Valor avulso',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                ),
                Text(
                  'R\$ ${Helper.intToMoney(20000)}',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 208,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
                ),
              ),
              Positioned(
                width: 67,
                height: 32,
                left: 20,
                top: 20,
                child: RaisedButton(
                  onPressed: () {},
                  padding: const EdgeInsets.all(0),
                  color: Color(0xffA5A5A5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '+INFO',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
