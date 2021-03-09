import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class CreditsBloc extends Disposable {
  CreditsRepository repository;

  CreditsBloc(this.repository);

  BehaviorSubject _currentProduct = BehaviorSubject();
  Sink get currentProductSink => _currentProduct.sink;
  Stream get currentProductStream => _currentProduct.stream;

  BehaviorSubject _creditProductSelected = BehaviorSubject();
  Sink get creditProductSelectedSink => _creditProductSelected.sink;
  Stream get creditProductSelectedStream => _creditProductSelected.stream;

  void setCurrentProduct(ProductModel product) {
    currentProductSink.add(product);
  }

  void setCurrentProductFromList(ProductList products) {
    if (!products.isLoading && !products.isEmpty && products.list.length > 0) {
      currentProductSink.add(products.list[0]);
    }
  }

  void fetchOffers() async {
    offersSink.add(Offers(isLoading: true, type: "FINAN", isEmpty: true));
    Offers offers = await repository.getOffers();
    offersSink.add(offers);
  }

  void fetchCreditOffers(String group) async {
    offersSink.add(Offers(isLoading: true, isEmpty: true, type: "CREDIT"));
    Offers offers = await repository.getOffersCreditProduct(group);
    offersSink.add(offers);
  }

  BehaviorSubject _indexFinancialController = BehaviorSubject.seeded(null);
  Sink get indexFinancialIn => _indexFinancialController.sink;
  Stream get indexFinancialOut => _indexFinancialController.stream;

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

  BehaviorSubject _offersController = BehaviorSubject();
  Sink get offersSink => _offersController.sink;
  Stream get offerStream => _offersController.stream;

  @override
  void dispose() {
    _creditProductSelected.close();
    _currentProduct.close();
    _offersController.close();
    _indexFinancialController.close();
    _indexProductController.close();
    _storeFinancialController.close();
  }
}
