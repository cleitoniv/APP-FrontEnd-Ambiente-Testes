import 'package:rxdart/subjects.dart';

class PaymentsWidgetBloc {
  BehaviorSubject _paymentTypeController = BehaviorSubject.seeded('À Vencer');
  Sink get paymentTypeIn => _paymentTypeController.sink;
  Stream<String> get paymentTypeOut => _paymentTypeController.stream.map(
        (event) => event,
      );
}
