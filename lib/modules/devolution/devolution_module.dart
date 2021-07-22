import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/devolution/confirm_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/devolution/devolution_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/devolution/effectuation_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DevolutionModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => i.get<DevolutionWidgetBloc>(),
    ),
  ];

  @override
  List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => DevolutionScreen()),
    ChildRoute('/confirm', child: (_, args) => ConfirmScreen()),
    ChildRoute('/effectuation', child: (_, args) => EffectuationScreen()),
  ];
}
