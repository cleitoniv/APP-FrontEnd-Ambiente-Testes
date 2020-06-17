import 'package:central_oftalmica_app_cliente/modules/notifications/notifications_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'notification_screen.dart';

class NotificationsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => NotificationsScreen(),
        ),
        Router(
          '/:id',
          child: (_, args) => NotificationScreen(
            id: int.parse(args.params['id']),
          ),
        ),
      ];
}
