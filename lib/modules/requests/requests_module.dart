import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => RequestsScreen(),
        )
      ];
}
