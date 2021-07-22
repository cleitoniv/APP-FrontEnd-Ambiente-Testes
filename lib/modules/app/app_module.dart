import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/intro_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/app/help_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/app/intro_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/app/main_app.dart';
import 'package:central_oftalmica_app_cliente/modules/app/ticket_module.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/auth_module.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_module.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/credito_financeiro_module.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_module.dart';
import 'package:central_oftalmica_app_cliente/modules/devolution/devolution_module.dart';
import 'package:central_oftalmica_app_cliente/modules/extracts/extracts_module.dart';
import 'package:central_oftalmica_app_cliente/modules/home/home_module.dart';
import 'package:central_oftalmica_app_cliente/modules/notifications/notifications_module.dart';
import 'package:central_oftalmica_app_cliente/modules/payments/payments_module.dart';
import 'package:central_oftalmica_app_cliente/modules/points/points_module.dart';
import 'package:central_oftalmica_app_cliente/modules/products/products_module.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/profile_module.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_module.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/notifications_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/payment_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => ClientHttp(),
      isSingleton: true,
    ),
    Bind(
      (i) => ProductRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => ProductBloc(
        i.get<ProductRepository>(),
      ),
    ),
    Bind(
      (i) => RequestsRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => RequestsBloc(
        i.get<RequestsRepository>(),
      ),
    ),
    Bind(
      (i) => CreditCardRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => CreditCardBloc(
        i.get<CreditCardRepository>(),
      ),
    ),
    Bind(
      (i) => PaymentRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => PaymentBloc(
        i.get<PaymentRepository>(),
      ),
    ),
    Bind(
      (i) => NotificationsRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => NotificationBloc(
        i.get<NotificationsRepository>(),
      ),
    ),
    Bind(
      (i) => CreditsRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => CreditsBloc(
        i.get<CreditsRepository>(),
      ),
    ),
    Bind(
      (i) => RequestsRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => RequestsBloc(
        i.get<RequestsRepository>(),
      ),
    ),
    Bind(
      (i) => UserRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => UserBloc(
        i.get<UserRepository>(),
      ),
    ),
    Bind(
      (i) => AuthRepository(
        i.get<ClientHttp>().getClient(),
      ),
    ),
    Bind(
      (i) => AuthBloc(
        i.get<AuthRepository>(),
      ),
    ),
    Bind((i) => CreditoFinanceiroBloc(repository: i.get<CreditsRepository>())),
    Bind(
      (i) => IntroWidgetBloc(),
    ),
    Bind(
      (i) => HomeWidgetBloc(),
    ),
    Bind(
      (i) => ProfileWidgetBloc(repository: i.get<UserRepository>()),
    ),
    Bind(
      (i) => AuthWidgetBloc(repository: i.get<AuthRepository>()),
    ),
    Bind(
      (i) => DevolutionWidgetBloc(repository: i.get<ProductRepository>()),
    ),
    Bind(
      (i) => PaymentsWidgetBloc(repository: i.get<PaymentRepository>()),
    ),
    Bind(
      (i) => ExtractWidgetBloc(repository: i.get<CreditsRepository>()),
    ),
    Bind(
      (i) => CartWidgetBloc(repository: i.get<CreditCardRepository>()),
    ),
    Bind(
      (i) => ProductWidgetBloc(),
    ),
    Bind(
      (i) => TicketBloc(
        i.get<UserRepository>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => MainApp(),
    ),
    ChildRoute(
      '/intro',
      child: (_, args) => IntroScreen(),
    ),
    ChildRoute(
      '/help',
      child: (_, args) => HelpScreen(),
    ),
    ModuleRoute(
      '/auth',
      module: AuthModule(),
    ),
    ModuleRoute(
      '/home',
      module: HomeModule(),
    ),
    ModuleRoute(
      '/credits',
      module: CreditsModule(),
    ),
    ModuleRoute(
      '/cart',
      module: CartModule(),
    ),
    ModuleRoute(
      '/requests',
      module: RequestsModule(),
    ),
    ModuleRoute(
      '/profile',
      module: ProfileModule(),
    ),
    ModuleRoute(
      '/points',
      module: PointsModule(),
    ),
    ModuleRoute(
      '/extracts',
      module: ExtractsModule(),
    ),
    ModuleRoute(
      '/notifications',
      module: NotificationsModule(),
    ),
    ModuleRoute(
      '/products',
      module: ProductsModule(),
    ),
    ModuleRoute(
      '/devolution',
      module: DevolutionModule(),
    ),
    ModuleRoute(
      '/payments',
      module: PaymentsModule(),
    ),
    ModuleRoute(
      '/credito_financeiro',
      module: CreditoFinanceiroModule(),
    ),
    ModuleRoute(
      '/ticket',
      module: TicketModule(),
    ),
  ];

  @override
  Widget get bootstrap => AppWidget();
}
