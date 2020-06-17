import 'package:rxdart/subjects.dart';

class CartWidgetBloc {
  BehaviorSubject _currentPaymentFormController = BehaviorSubject.seeded(0);
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream<int> get currentPaymentFormOut =>
      _currentPaymentFormController.stream.map(
        (event) => event,
      );
}
