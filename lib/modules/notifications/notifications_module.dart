import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/notifications/notifications_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationsModule extends Module {
  @override
  List<Bind> binds = [
    Bind((i) => i.get<NotificationBloc>()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => NotificationsScreen(),
    ),
  ];
}
