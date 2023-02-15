import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class PaymentMethod {
  bool isBoleto;
  VindiCardModel creditCard;
  bool isEmpty;
  PaymentMethod({this.creditCard, this.isBoleto, this.isEmpty = false});
}

class CartWidgetBloc extends Disposable {
  PaymentMethod _paymentMethod;

  CreditCardRepository repository;

  CartWidgetBloc({this.repository});

  Future<bool> setPaymentMethodCartao(VindiCardModel card) async {
    currentPaymentFormIn.add(PaymentMethod(isBoleto: false, creditCard: card));
    return true;
  }

  void setPaymentMethodBoleto(bool billing) {
    currentPaymentFormIn.add(PaymentMethod(isBoleto: true));
  }

  PaymentMethod get currentPaymentMethod => this._paymentMethod;

  BehaviorSubject _cartTotalItems = BehaviorSubject.seeded(0);
  Sink get cartTotalItemsSink => _cartTotalItems.sink;
  Stream get cartTotalItemsStream => _cartTotalItems.stream;
  get currentCartTotalItems => _cartTotalItems.value;

  BehaviorSubject _currentPaymentFormController = BehaviorSubject.seeded(null);
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream get currentPaymentFormOut => _currentPaymentFormController.stream;
  get currentPaymentFormValue => _currentPaymentFormController.value;

  @override
  void dispose() {
    _currentPaymentFormController.close();
    _cartTotalItems.close();
  }
}
