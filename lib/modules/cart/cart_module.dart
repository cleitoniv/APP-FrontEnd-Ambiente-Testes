import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/add_credit_card_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/payment_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CartModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<CartWidgetBloc>(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => CartScreen(),
        ),
        Router(
          '/payment',
          child: (_, args) => PaymentScreen(),
        ),
        Router(
          '/addCreditCard',
          child: (_, args) => AddCreditCardScreen(),
        )
      ];
}
