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
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => PointsScreen(),
        ),
        Router(
          '/add',
          child: (_, args) => AddPointsScreen(),
        ),
        Router(
          '/rescue',
          child: (_, args) => RescuePointsScreen(),
        )
      ];
}
