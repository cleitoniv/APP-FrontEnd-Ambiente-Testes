import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/models/credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  ClientHttp clientHttp = ClientHttp();
  ProductRepository productRepository =
      ProductRepository(clientHttp.getClient());
  CreditsRepository creditsRepository =
      CreditsRepository(clientHttp.getClient());
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

  test(
    'show products - repository',
    () async {
      ProductModel _product = await productRepository.show(id: 1);

      expectLater(
        _product.title.isNotEmpty,
        true,
      );
    },
  );

  test(
    'index financial credits - repository',
    () async {
      FinancialCreditModel _credits = await creditsRepository.indexFinancial();

      expectLater(
        _credits.credits.isNotEmpty,
        true,
      );
    },
  );

  test(
    'index product credits - repository',
    () async {
      ProductCreditModel _credits = await creditsRepository.indexProduct();

      expectLater(
        _credits.products.isNotEmpty,
        true,
      );
    },
  );
}
