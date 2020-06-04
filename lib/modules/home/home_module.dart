import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/home/tabs_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<HomeWidgetBloc>()),
        Bind((i) => i.get<RequestsBloc>()),
        Bind((i) => i.get<AuthBloc>()),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/:index',
          child: (_, args) => TabsScreen(
            index: int.parse(args.params['index']),
          ),
        ),
      ];
}
