import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/intro_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/config/client_http.dart';
import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/app/help_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/app/intro_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/auth_module.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_module.dart';
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
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => ClientHttp(),
          singleton: true,
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
          (i) => IntroWidgetBloc(),
        ),
        Bind(
          (i) => HomeWidgetBloc(),
        ),
        Bind(
          (i) => ProfileWidgetBloc(),
        ),
        Bind(
          (i) => AuthWidgetBloc(),
        ),
        Bind(
          (i) => DevolutionWidgetBloc(),
        ),
        Bind(
          (i) => PaymentsWidgetBloc(),
        ),
        Bind(
          (i) => ExtractWidgetBloc(),
        ),
        Bind(
          (i) => CartWidgetBloc(),
        ),
        Bind(
          (i) => ProductWidgetBloc(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/intro',
          child: (_, args) => IntroScreen(),
        ),
        Router(
          '/help',
          child: (_, args) => HelpScreen(),
        ),
        Router(
          '/auth',
          module: AuthModule(),
        ),
        Router(
          '/home',
          module: HomeModule(),
        ),
        Router(
          '/credits',
          module: CreditsModule(),
        ),
        Router(
          '/cart',
          module: CartModule(),
        ),
        Router(
          '/requests',
          module: RequestsModule(),
        ),
        Router(
          '/profile',
          module: ProfileModule(),
        ),
        Router(
          '/points',
          module: PointsModule(),
        ),
        Router(
          '/extracts',
          module: ExtractsModule(),
        ),
        Router(
          '/notifications',
          module: NotificationsModule(),
        ),
        Router(
          '/products',
          module: ProductsModule(),
        ),
        Router(
          '/devolution',
          module: DevolutionModule(),
        ),
        Router(
          '/payments',
          module: PaymentsModule(),
        ),
      ];

  @override
  Widget get bootstrap => AppWidget();
}
