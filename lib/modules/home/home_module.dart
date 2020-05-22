import 'package:central_oftalmica_app_cliente/modules/home/tabs_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/:index',
          child: (_, args) => TabsScreen(
            currentIndex: int.parse(args.params['index']),
          ),
        ),
      ];
}
