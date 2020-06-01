import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
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
      ];

  @override
  List<Router> get routers => [
        Router(
          '/:id',
          child: (_, args) => ProductScreen(
            id: int.parse(args.params['id']),
          ),
        ),
        Router(
          '/:id/requestDetails',
          child: (_, args) => RequestDetailsScreen(),
        ),
      ];
}
