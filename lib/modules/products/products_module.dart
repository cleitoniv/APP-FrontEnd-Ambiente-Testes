import 'package:central_oftalmica_app_cliente/modules/products/product_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/:id',
          child: (_, args) => ProductScreen(
            id: int.parse(args.params['id']),
          ),
        )
      ];
}
