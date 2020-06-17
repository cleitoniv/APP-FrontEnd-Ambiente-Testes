import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/extracts/extracts_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtractsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<ExtractWidgetBloc>(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => ExtractsScreen(),
        )
      ];
}
