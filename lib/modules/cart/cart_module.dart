import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/add_credit_card_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/payment_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/product_cart_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CartModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<CartWidgetBloc>(),
        ),
        Bind(
          (i) => i.get<RequestsBloc>(),
        ),
        Bind(
          (i) => i.get<HomeWidgetBloc>(),
        ),
        Bind(
          (i) => i.get<PaymentBloc>(),
        ),
        Bind(
          (i) => i.get<CreditCardBloc>(),
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => CartScreen(),
        ),
        ModularRouter('/product', child: (_, args) => ProductCartScreen()),
        ModularRouter(
          '/payment',
          child: (_, args) => PaymentScreen(),
        ),
        ModularRouter(
          '/addCreditCard',
          child: (_, args) => AddCreditCardScreen(),
        )
      ];
}
