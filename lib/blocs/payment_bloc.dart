import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/repositories/payment_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaymentBloc extends Disposable {
  PaymentRepository repository;

  PaymentBloc(this.repository);

  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

  Future<bool> payment(Map<String, dynamic> data, bool isBoleto) async {
    PaymentMethod _paymentMethod = _cartWidgetBloc.currentPaymentFormValue;
    return await repository.payment(data, _paymentMethod, isBoleto);
  }

  @override
  void dispose() {}
}
