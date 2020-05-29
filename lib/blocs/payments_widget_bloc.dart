import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class PaymentsWidgetBloc extends Disposable {
  BehaviorSubject _paymentTypeController = BehaviorSubject.seeded('À Vencer');
  Sink get paymentTypeIn => _paymentTypeController.sink;
  Stream<String> get paymentTypeOut => _paymentTypeController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _paymentTypeController.close();
  }
}
