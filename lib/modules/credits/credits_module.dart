import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<HomeWidgetBloc>()),
        Bind((i) => i.get<CreditsBloc>()),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => CreditsScreen(),
        ),
      ];
}
