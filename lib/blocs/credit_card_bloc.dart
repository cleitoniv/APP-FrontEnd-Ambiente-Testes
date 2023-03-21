import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
// import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
// import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/vindi_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';

// import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class CreditCardBloc extends Bloc<CreditCardModel> {
  VindiRepository vindiRepository;

  CreditCardRepository repository;

  CreditCardBloc(this.repository, this.vindiRepository);

  // CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

  Future<void> fetchPaymentMethods() async {
    print('linha 23');
    this.cartaoCreditoSink.add(CreditCardList(isLoading: true));
    CreditCardList list = await repository.index();
    this.cartaoCreditoSink.add(list);
  }

  Future<void> fetchPaymentMethodsFinan() async {
    print('linha 30');
    this.cartaoCreditoSink.add(CreditCardList(isLoading: true));
    CreditCardList list = await repository.index();
    this.cartaoCreditoSink.add(list);
  }

  Future<void> fetchPaymentMethodsChange() async {
    print('linha 37');
    this.cartaoCreditoSink.add(CreditCardList(isLoading: true));
    CreditCardList list = await repository.index();
    this.cartaoCreditoSink.add(list);
  }

  Future<List> fetchInstallments(int valor, bool isBoleto) async {
    print('linha 41');
    return repository.fetchInstallments(valor, isBoleto);
  }

  Future<VindiCreditCard> addVindiCreditCard(CreditCardModel creditCard) {
    print('linha 45');
    inspect(creditCard);
    return vindiRepository.addVindiCreditCard(creditCard);
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
  get cartaoCreditoValue => _cartaoCredito.value;

  BehaviorSubject _currentPaymentFormController = BehaviorSubject();
  Sink get currentPaymentFormIn => _currentPaymentFormController.sink;
  Stream get currentPaymentFormOut => _currentPaymentFormController.stream;
  get currentPaymentValue => _currentPaymentFormController.value;

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
