import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CartModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  // TODO: implement routers
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => CartScreen(),
        )
      ];
}
