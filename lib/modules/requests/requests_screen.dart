import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RequestsScreen extends StatelessWidget {
  _onShowRequest(int id) {
    Modular.to.pushNamed('/requests/$id');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(
          height: 20,
        ),
        itemBuilder: (context, index) {
          return ListTileMoreCustomizable(
            contentPadding: const EdgeInsets.all(0),
            onTap: (value) => _onShowRequest(1),
            horizontalTitleGap: 10,
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffECECEC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '15\nAgo',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Marcos Barbosa Santos',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                      ),
                ),
                Text(
                  'Valor',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                      ),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Pedido 282740',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'R\$ 120,00',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                              ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).accentColor,
                        )
                      ],
                    ),
                  ],
                ),
                Text(
                  'Previsão de entrega: 22/05/2020',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black26,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
