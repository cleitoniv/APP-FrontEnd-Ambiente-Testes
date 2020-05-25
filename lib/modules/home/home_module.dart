import 'package:central_oftalmica_app_cliente/blocs/widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/home/tabs_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<WidgetBloc>()),
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
