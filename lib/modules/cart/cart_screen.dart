import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CartScreen extends StatelessWidget {
  _onBack() {}

  _onSubmit() {
    Modular.to.pushNamed(
      '/cart/payment',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          ListView.separated(
            primary: false,
            addSemanticIndexes: true,
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) => Divider(
              height: 25,
              thickness: 1,
              color: Colors.black12,
            ),
            itemBuilder: (context, index) {
              return ListTileMoreCustomizable(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 10,
                leading: Image.network(
                  'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
                ),
                title: Text(
                  'Bioview Asferica Cx 6',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                      ),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      'Qnt. 2',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                    ),
                    SizedBox(width: 20),
                    CircleAvatar(
                      backgroundColor: Color(0xff707070),
                      radius: 10,
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Avulso',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'R\$ ${Helper.intToMoney(20000)}',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: Theme.of(context).accentColor,
                    )
                  ],
                ),
              );
            },
          ),
          Divider(
            height: 25,
            thickness: 1,
            color: Colors.black12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Taxa de entrega',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 14,
                    ),
              ),
              Text(
                'R\$ ${Helper.intToMoney(20000)}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 14,
                    ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 18,
                    ),
              ),
              Text(
                'R\$ ${Helper.intToMoney(20000)}',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 18,
                    ),
              ),
            ],
          ),
          SizedBox(height: 30),
          RaisedButton.icon(
            color: Color(0xffF1F1F1),
            elevation: 0,
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).accentColor,
            ),
            label: Text(
              'Continue Comprando',
              style: Theme.of(context).textTheme.button.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onPressed: _onBack,
          ),
          SizedBox(height: 20),
          RaisedButton(
            elevation: 0,
            child: Text(
              'Finalizar Pedido',
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }
}
