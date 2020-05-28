import 'package:central_oftalmica_app_cliente/modules/points/add_points_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/points/points_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PointsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => PointsScreen(),
        ),
        Router(
          '/add',
          child: (_, args) => AddPointsScreen(),
        )
      ];
}
