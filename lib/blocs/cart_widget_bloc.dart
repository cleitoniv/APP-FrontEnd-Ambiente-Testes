import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class PaymentMethod {
  bool isBoleto;
  CreditCardModel creditCard;
  PaymentMethod({this.creditCard, this.isBoleto});
}

class CartWidgetBloc extends Disposable {
  PaymentMethod _paymentMethod;

  CreditCardRepository repository;

  CartWidgetBloc({this.repository});

  Future<bool> setPaymentMethodCartao(CreditCardModel card) async {
    bool selectedCard = await repository.selectCreditCard(card.id);

    if (selectedCard) {
      this._paymentMethod = PaymentMethod(isBoleto: false, creditCard: card);
      currentPaymentFormIn.add(this._paymentMethod);
      return true;
    } else {
      return false;
    }
  }

  void setPaymentMethodBoleto(bool billing) {
    this._paymentMethod = PaymentMethod(isBoleto: billing);
  }

  PaymentMethod get currentPaymentMethod => this._paymentMethod;

  BehaviorSubject _cartTotalItems = BehaviorSubject.seeded(0);
  Sink get cartTotalItemsSink => _cartTotalItems.sink;
  Stream get cartTotalItemsStream => _cartTotalItems.stream;
  get currentCartTotalItems => _cartTotalItems.value;

  BehaviorSubject _currentPaymentFormController = BehaviorSubject.seeded(null);
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream<CreditCardModel> get currentPaymentFormOut =>
      _currentPaymentFormController.stream.map(
        (event) {
          print("EVENT");
          this.setPaymentMethodCartao(event);
          return event;
        },
      );

  @override
  void dispose() {
    _currentPaymentFormController.close();
    _cartTotalItems.close();
  }
}
