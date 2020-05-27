import 'package:central_oftalmica_app_cliente/modules/devolution/add_product_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DevolutionModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => AddProductScreen()),
      ];
}
