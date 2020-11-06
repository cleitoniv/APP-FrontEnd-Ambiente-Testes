import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

import '../repositories/credits_repository.dart';

class CreditCardBloc extends Bloc<CreditCardModel> {
  CreditCardRepository repository;

  CreditCardBloc(this.repository);

  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

  void fetchPaymentMethods() async {
    this.cartaoCreditoSink.add(CreditCardList(isLoading: true));
    CreditCardList list = await repository.index();
    try {
      CreditCardModel currentCard =
          list.list.firstWhere((element) => element.status == 1);
      currentPaymentFormIn.add(currentCard);
      _cartWidgetBloc.setPaymentMethodCartao(currentCard);
      this.cartaoCreditoSink.add(list);
    } catch (e) {
      if (list.list.length > 0) {
        currentPaymentFormIn.add(list.list[0]);
        _cartWidgetBloc.setPaymentMethodCartao(list.list[0]);
        this.cartaoCreditoSink.add(list);
      } else {
        this
            .cartaoCreditoSink
            .add(CreditCardList(isEmpty: true, isLoading: false));
      }
    }
  }

  Future<List> fetchInstallments(int valor, bool isBoleto) async {
    return repository.fetchInstallments(valor, isBoleto);
  }

  Future<CreditCard> addCreditCard(CreditCardModel creditCard) {
    return repository.addCreditCard(creditCard);
  }

  BehaviorSubject _storeController = BehaviorSubject.seeded(null);
  @override
  Sink get storeIn => _storeController.sink;
  @override
  Stream<String> get storeOut => _storeController.stream.asyncMap(
        (event) => repository.store(model: event),
      );

  BehaviorSubject _cartaoCredito = BehaviorSubject();
  Sink get cartaoCreditoSink => _cartaoCredito.sink;
  Stream get cartaoCreditoStream => _cartaoCredito.stream;

  BehaviorSubject _currentPaymentFormController = BehaviorSubject();
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream get currentPaymentFormOut => _currentPaymentFormController.stream;

  Future<RemoveCard> removeCard(int id) async {
    return repository.removeCard(id);
  }

  @override
  void dispose() {
    _currentPaymentFormController.close();
    _cartaoCredito.close();
    _storeController.close();
  }
}
