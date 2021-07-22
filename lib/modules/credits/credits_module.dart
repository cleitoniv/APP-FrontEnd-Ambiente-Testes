import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => i.get<HomeWidgetBloc>()),
    Bind((i) => i.get<CreditsBloc>()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => CreditsScreen(),
    ),
  ];
}
