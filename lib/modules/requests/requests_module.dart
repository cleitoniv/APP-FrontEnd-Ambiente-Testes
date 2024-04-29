import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/reposicao_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/request_info_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => i.get<HomeWidgetBloc>(),
    ),
    Bind(
      (i) => i.get<RequestsBloc>(),
    ),
    Bind(
      (i) => i.get<ProductBloc>(),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => RequestsScreen(),
    ),
    ChildRoute(
      '/reposition',
      child: (_, args) => RepositionScreen(),
    ),
    ChildRoute(
      '/:id',
      child: (_, args) => RequestInfoScreen(
        id: args.params['id'],
        pedidoData: args.data["pedidoData"],
        reposicao: args.data["reposicao"],
      ),
    )
  ];
}
