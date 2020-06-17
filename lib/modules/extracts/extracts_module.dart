import 'package:central_oftalmica_app_cliente/modules/extracts/extracts_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtractsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => ExtractsScreen(),
        )
      ];
}
