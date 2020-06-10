import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class CartWidgetBloc extends Disposable {
  BehaviorSubject _currentPaymentFormController = BehaviorSubject.seeded(null);
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream<CreditCardModel> get currentPaymentFormOut =>
      _currentPaymentFormController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _currentPaymentFormController.close();
  }
}
