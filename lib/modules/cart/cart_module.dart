import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_card_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/payment_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/add_credit_card_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/payment_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/finish_payment_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/product_cart_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CartModule extends Module {
  @override
  final List<Bind> binds = [
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
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => CartScreen(),
    ),
    ChildRoute('/product', child: (_, args) => ProductCartScreen()),
    ChildRoute(
      '/payment',
      child: (_, args) => PaymentScreen(),
    ),
    ChildRoute(
      '/addCreditCard',
      child: (_, args) => AddCreditCardScreen(screen: args.data),
    ),
    ChildRoute(
      '/finishPayment',
      child: (_, args) => FinishPayment(),
    )
  ];
}
