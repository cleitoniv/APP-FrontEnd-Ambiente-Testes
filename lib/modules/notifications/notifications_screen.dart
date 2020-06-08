import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationBloc _notificationBloc = Modular.get<NotificationBloc>();

  _onTap(NotificationModel notification) {}

  String _renderIcon(NotificationModel notification) {
    switch (notification.type) {
      case 'payment':
        return 'assets/icons/drawer_6.png';
      case 'points':
        return 'assets/icons/drawer_5.png';
      case 'devolution':
        return 'assets/icons/drawer_4.png';
      case 'billet':
        return 'assets/icons/blue_barcode.png';
      case 'product_credit':
        return 'assets/icons/blue_openbox.png';
      case 'financial_credit':
        return 'assets/icons/money.png';
      case 'delivery':
        return 'assets/icons/truck.png';
      case 'replacement':
        return 'assets/icons/refresh.png';
      default:
        return 'assets/icons/drawer_6.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        centerTitle: false,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: _notificationBloc.indexOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<NotificationModel> _notifications = snapshot.data;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _notifications.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 20,
            ),
            itemBuilder: (context, index) {
              return Opacity(
                opacity: _notifications[index].isRead ? 0.5 : 1,
                child: ListTileMoreCustomizable(
                  onTap: (value) => _onTap(
                    _notifications[index],
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  leading: Image.asset(
                    _renderIcon(
                      _notifications[index],
                    ),
                    width: 25,
                    height: 25,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _notifications[index].title,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 16,
                            ),
                      ),
                      Text(
                        Helper.dateToMonth(
                          _notifications[index].date,
                        ).replaceAll('de', '').replaceAll('\n', ''),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    _notifications[index].subtitle,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
