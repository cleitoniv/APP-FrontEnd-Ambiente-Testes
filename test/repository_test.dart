import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/models/credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/notifications_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  ClientHttp clientHttp = ClientHttp();
  ProductRepository productRepository =
      ProductRepository(clientHttp.getClient());
  CreditsRepository creditsRepository =
      CreditsRepository(clientHttp.getClient());
  UserRepository userRepository = UserRepository(clientHttp.getClient());
  RequestsRepository requestsRepository =
      RequestsRepository(clientHttp.getClient());
  NotificationsRepository notificationsRepository =
      NotificationsRepository(clientHttp.getClient());

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

  test(
    'store financial credits - repository',
    () async {
      String data = await creditsRepository.storeFinancial(100);

      expectLater(
        data.isNotEmpty,
        true,
      );
    },
  );

  test(
    'current user - repository',
    () async {
      UserModel user = await userRepository.currentUser();

      expectLater(
        user.name.isNotEmpty,
        true,
      );
    },
  );

  test(
    'add points - repository',
    () async {
      String data = await userRepository.addPoints({
        'serial_number': '0000',
        'patient_name': '',
        'patient_reference_number': '3423',
        'patient_birthday': '10/05/100'
      });

      expectLater(
        data.isNotEmpty,
        true,
      );
    },
  );

  test(
    'index requests - repository',
    () async {
      List<RequestModel> _requests = await requestsRepository.index(filter: {
        'status': 'pendent',
      });

      expectLater(
        _requests.isNotEmpty,
        true,
      );
    },
  );

  test(
    'index notifications - repository',
    () async {
      List<NotificationModel> _notifications =
          await notificationsRepository.index();

      expectLater(
        _notifications.isNotEmpty,
        true,
      );
    },
  );
}
