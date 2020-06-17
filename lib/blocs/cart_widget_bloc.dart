import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class CartWidgetBloc extends Disposable {
  BehaviorSubject _currentPaymentFormController = BehaviorSubject.seeded(0);
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream<int> get currentPaymentFormOut =>
      _currentPaymentFormController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _currentPaymentFormController.close();
  }
}
