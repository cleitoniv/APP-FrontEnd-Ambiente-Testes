import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/points/add_points_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/points/points_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/points/rescue_points_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PointsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<UserBloc>()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => PointsScreen(),
        ),
        ModularRouter(
          '/add',
          child: (_, args) => AddPointsScreen(),
        ),
        ModularRouter(
          '/rescue',
          child: (_, args) => RescuePointsScreen(),
        )
      ];
}
