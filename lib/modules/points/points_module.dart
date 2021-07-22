import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/points/add_points_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/points/points_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/points/rescue_points_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PointsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => i.get<UserBloc>()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => PointsScreen(),
    ),
    ChildRoute(
      '/add',
      child: (_, args) => AddPointsScreen(),
    ),
    ChildRoute(
      '/rescue',
      child: (_, args) => RescuePointsScreen(),
    )
  ];
}
