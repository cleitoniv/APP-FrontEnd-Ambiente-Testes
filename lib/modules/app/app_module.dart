import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/auth_module.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router('/auth', module: AuthModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
