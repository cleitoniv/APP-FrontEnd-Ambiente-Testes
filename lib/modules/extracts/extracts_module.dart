import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/extracts/extracts_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtractsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => i.get<ExtractWidgetBloc>(),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => ExtractsScreen(),
    )
  ];
}
