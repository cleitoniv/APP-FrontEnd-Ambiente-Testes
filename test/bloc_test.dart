import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/config/client_http.dart';
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
          (ProductModel credits) => credits.title.isNotEmpty,
        ),
      );
    },
  );

  test(
    'index financial credits - bloc',
    () async {
      CreditsBloc _bloc = CreditsBloc(creditsRepository);

      expectLater(
        _bloc.indexFinancialOut,
        emits(
          (FinancialCreditModel credits) => credits.credits.isNotEmpty,
        ),
      );
    },
  );

  test(
    'index product credits - bloc',
    () async {
      CreditsBloc _bloc = CreditsBloc(creditsRepository);

      expectLater(
        _bloc.indexProductOut,
        emits(
          (ProductCreditModel credits) => credits.products.isNotEmpty,
        ),
      );
    },
  );

  test(
    'store financial credits - bloc',
    () async {
      CreditsBloc _bloc = CreditsBloc(creditsRepository);

      _bloc.storeFinancialIn.add(200);

      expectLater(
        _bloc.storeFinancialOut,
        emits(
          (String data) => data.isNotEmpty,
        ),
      );
    },
  );

  test(
    'current user - bloc',
    () async {
      UserBloc _bloc = UserBloc(userRepository);

      expectLater(
        _bloc.currentUserOut,
        emits(
          (UserModel user) => user.name.isNotEmpty,
        ),
      );
    },
  );

  test(
    'add points - bloc',
    () async {
      UserBloc _bloc = UserBloc(userRepository);

      _bloc.addPointsIn.add({
        'serial_number': '0000',
        'patient_name': '',
        'patient_reference_number': '3423',
        'patient_birthday': '10/05/100'
      });

      expectLater(
        _bloc.addPointsOut,
        emits(
          (String data) => data.isNotEmpty,
        ),
      );
    },
  );

  test(
    'index requests - bloc',
    () async {
      RequestsBloc _bloc = RequestsBloc(requestsRepository);

      expectLater(
        _bloc.indexOut,
        emits(
          (List<RequestModel> requests) => requests.isNotEmpty,
        ),
      );
    },
  );

  test(
    'index notifications - bloc',
    () async {
      NotificationBloc _bloc = NotificationBloc(notificationsRepository);

      expectLater(
        _bloc.indexOut,
        emits(
          (List<NotificationModel> notifications) => notifications.isNotEmpty,
        ),
      );
    },
  );
}
