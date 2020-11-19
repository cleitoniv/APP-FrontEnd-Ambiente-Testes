import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/request_info_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestsModule extends ChildModule {
  @override
  List<Bind> get binds => [
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
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => RequestsScreen(),
        ),
        ModularRouter(
          '/:id',
          child: (_, args) => RequestInfoScreen(
            id: int.parse(args.params['id']),
            pedidoData: args.data["pedidoData"],
            reposicao: args.data["reposicao"],
          ),
        )
      ];
}
