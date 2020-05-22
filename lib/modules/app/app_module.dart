import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/auth_module.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_module.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_module.dart';
import 'package:central_oftalmica_app_cliente/modules/home/home_module.dart';
import 'package:central_oftalmica_app_cliente/modules/notifications/notifications_module.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/profile_module.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_module.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => ClientHttp(),
          singleton: true,
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/auth',
          module: AuthModule(),
        ),
        Router(
          '/home',
          module: HomeModule(),
        ),
        Router(
          '/credits',
          module: CreditsModule(),
        ),
        Router(
          '/cart',
          module: CartModule(),
        ),
        Router(
          '/requests',
          module: RequestsModule(),
        ),
        Router(
          '/profile',
          module: ProfileModule(),
        ),
        Router(
          '/notifications',
          module: NotificationsModule(),
        ),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
