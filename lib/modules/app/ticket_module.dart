import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/app/ticket_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TicketModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => i.get<HomeWidgetBloc>()),
    Bind(
      (i) => i.get<TicketBloc>(),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => TicketScreen(),
    ),
  ];
}
