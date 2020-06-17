import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/devolution/devolution_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DevolutionModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<DevolutionWidgetBloc>(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => DevolutionScreen()),
      ];
}
