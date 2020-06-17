import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class NotificationsScreen extends StatelessWidget {
  _handleTap() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(
          height: 20,
        ),
        itemBuilder: (context, index) {
          return ListTileMoreCustomizable(
            onTap: (value) => _handleTap(),
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0,
            leading: Image.asset(
              'assets/icons/drawer_6.png',
              width: 25,
              height: 25,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Pedido confirmado',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 16,
                      ),
                ),
                Text(
                  '05 Jan',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                        color: Colors.black38,
                      ),
                ),
              ],
            ),
            subtitle: Text(
              'Pagamento confirmado e a previsão de entrega é para 22/07/2019',
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
