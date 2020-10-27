import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/products/product_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/products/request_details_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<ProductBloc>(),
        ),
        Bind(
          (i) => i.get<ProductWidgetBloc>(),
        ),
        Bind(
          (i) => i.get<RequestsBloc>(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/:id',
          child: (_, args) => ProductScreen(id: 0, product: args.data),
        ),
        Router(
          '/:id/requestDetails',
          child: (_, args) => RequestDetailsScreen(
            id: 0,
            type: args.data,
          ),
        ),
      ];
}
