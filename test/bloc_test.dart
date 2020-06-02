import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
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
    'index products - bloc',
    () async {
      ProductBloc _bloc = ProductBloc(productRepository);

      expectLater(
        _bloc.indexOut,
        emits(
          (List<ProductModel> products) => products.isNotEmpty,
        ),
      );
    },
  );

  test(
    'show products - bloc',
    () async {
      ProductBloc _bloc = ProductBloc(productRepository);

      _bloc.showIn.add(1);

      expectLater(
        _bloc.showOut,
        emits(
          (ProductModel product) => product.title.isNotEmpty,
        ),
      );
    },
  );
}
