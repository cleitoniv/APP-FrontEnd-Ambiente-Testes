import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CreditsBloc extends Disposable {
  CreditsRepository repository;

  CreditsBloc(this.repository);

  BehaviorSubject _indexFinancialController = BehaviorSubject.seeded(null);
  Sink get indexFinancialIn => _indexFinancialController.sink;
  Stream<FinancialCreditModel> get indexFinancialOut =>
      _indexFinancialController.stream.asyncMap(
        (event) => repository.indexFinancial(),
      );

  BehaviorSubject _indexProductController = BehaviorSubject.seeded(null);
  Sink get indexProductIn => _indexProductController.sink;
  Stream<ProductCreditModel> get indexProductOut =>
      _indexProductController.stream.asyncMap(
        (event) => repository.indexProduct(),
      );

  BehaviorSubject _storeFinancialController = BehaviorSubject.seeded(null);
  Sink get storeFinancialIn => _storeFinancialController.sink;
  Stream<String> get storeFinancialOut =>
      _storeFinancialController.stream.asyncMap(
        (event) => repository.storeFinancial(event),
      );

  @override
  void dispose() {
    _indexFinancialController.close();
    _indexProductController.close();
    _storeFinancialController.close();
  }
}
