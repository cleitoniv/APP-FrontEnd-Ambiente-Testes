import 'package:central_oftalmica_app_cliente/repositories/payment_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class PaymentBloc extends Disposable {
  PaymentRepository repository;

  PaymentBloc(this.repository);

  BehaviorSubject _paymentController = BehaviorSubject.seeded(null);
  Sink get paymentIn => _paymentController.sink;
  Stream<String> get paymentOut => _paymentController.stream.asyncMap(
        (event) => repository.payment(event),
      );

  @override
  void dispose() {
    _paymentController.close();
  }
}
