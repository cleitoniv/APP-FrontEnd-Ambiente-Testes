import 'package:central_oftalmica_app_cliente/modules/point/points_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PointsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => PointsScreen(),
        )
      ];
}
