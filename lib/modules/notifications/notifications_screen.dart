import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationBloc _notificationBloc = Modular.get<NotificationBloc>();

  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();

  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();

  PaymentsWidgetBloc _paymentsWidgetBloc = Modular.get<PaymentsWidgetBloc>();

  ExtractWidgetBloc _extractWidgetBloc = Modular.get<ExtractWidgetBloc>();

  _onTap(NotificationModel notification) async {
    await _notificationBloc.readNotification(notification.id);
    _notificationBloc.fetchNotifications();
    if (notification.type == "PEDIDO_CONFIRMADO") {
      Modular.to.pushNamed('/home/3');
    } else if (notification.type == "RESGATE_PONTOS") {
      Modular.to.pushNamed("/points");
    } else if (notification.type == "PEDIDO_ENTREGUE") {
      _requestsBloc.currentRequestFilterSink.add(1);
      Modular.to.pushNamed("/home/3");
      _homeWidgetBloc.currentRequestTypeIn.add("Entregues");
    } else if (notification.type == "REPOSICAO_PEDIDOS") {
      _requestsBloc.currentRequestFilterSink.add(2);
      Modular.to.pushNamed("/home/3");
      _homeWidgetBloc.currentRequestTypeIn.add("Reposição");
    } else if (notification.type == "BOLETO_VENCER") {
      Modular.to.pushNamed("/payments");
    } else if (notification.type == "BOLETO_VENCIDO") {
      _paymentsWidgetBloc.paymentsFilter.add(2);
      Modular.to.pushNamed("/payments");
      _paymentsWidgetBloc.paymentTypeIn.add('Vencidas');
    } else if (notification.type == "FINANCEIRO_ADQUIRIDO") {
      _extractWidgetBloc.extractTypeIn.add("Financeiro");
      _extractWidgetBloc.currentPageSink.add({'type': "Financeiro", 'page': 0});
      Modular.to.pushNamed("/extracts");
    } else if (notification.type == "PRODUTO_ADQUIRIDO") {
      _extractWidgetBloc.extractTypeIn.add("Produto");
      _extractWidgetBloc.currentPageSink.add({'type': "Produto", 'page': 1});
      Modular.to.pushNamed("/extracts");
    }
  }

  String _renderIcon(NotificationModel notification) {
    switch (notification.type) {
      case 'PEDIDO_CONFIRMADO':
        return 'assets/icons/drawer_6.png';
      case 'RESGATE_PONTOS':
        return 'assets/icons/drawer_5.png';
      case 'SOLICITACAO_DEV':
        return 'assets/icons/drawer_4.png';
      case 'EFETIVACAO_DEV':
        return 'assets/icons/drawer_4.png';
      case 'BOLETO_VENCIDO':
        return 'assets/icons/blue_barcode.png';
      case 'BOLETO_VENCER':
        return 'assets/icons/blue_barcode.png';
      case 'PRODUTO_ADQUIRIDO':
        return 'assets/icons/blue_openbox.png';
      case 'FINANCEIRO_ADQUIRIDO':
        return 'assets/icons/money.png';
      case 'PEDIDO_ENTREGUE':
        return 'assets/icons/truck.png';
      case 'REPOSICAO_PEDIDOS':
        return 'assets/icons/refresh.png';
      default:
        return 'assets/icons/drawer_6.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _notificationBloc.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: _notificationBloc.notificationsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text(
                  "Nao foi possivel carregar suas notificacoes no momento."),
            );
          }

          List<NotificationModel> _notifications = snapshot.data.list;
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
