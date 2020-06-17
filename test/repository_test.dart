import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  ClientHttp clientHttp = ClientHttp();
  ProductRepository productRepository =
      ProductRepository(clientHttp.getClient());

  test(
    'index products - repository',
    () async {
      List<ProductModel> _products = await productRepository.index();

      expectLater(
        _products.isNotEmpty,
        true,
      );
    },
  );
}
