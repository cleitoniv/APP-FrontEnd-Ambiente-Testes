import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/notifications/notifications_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<NotificationBloc>()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => NotificationsScreen(),
        ),
      ];
}
