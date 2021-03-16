import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/app/ticket_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TicketModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<HomeWidgetBloc>()),
        Bind(
          (i) => i.get<TicketBloc>(),
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => TicketScreen(),
        ),
      ];
}
