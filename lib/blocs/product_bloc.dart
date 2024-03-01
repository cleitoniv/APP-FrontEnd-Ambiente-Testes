import 'dart:async';
import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc extends Disposable {
  ProductRepository repository;

  ProductBloc(this.repository);

  Product _currentProduct;

  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();

  Product get currentProduct => this._currentProduct;

  void setCurrentProduct(Product product) {
    this._currentProduct = product;
  }

  Future<void> favorites(AuthEvent event) async {
    List favorites = await this.repository.favorites(event);
    favoriteProductListSink.add(favorites);
  }

  Future<bool> favorite(String group) async {
    return this.repository.favorite(group);
  }

  void fetchProducts(String filtro) async {
    productListSink.add(ProductList(isEmpty: true, isLoading: true));
    ProductList list = await repository.productList(filtro);
    productListSink.add(list);
  }

  bool validateProductTest(int qtd) {
    if (this._currentProduct.product.tests - qtd > 0) {
      this._currentProduct.product.productTests =
          this._currentProduct.product.tests - qtd;
      productSink.add(this._currentProduct);
      return true;
    } else {
      return false;
    }
  }

  void fetchProduct(int id) async {
    productSink.add(Product(isLoading: true));
    this._currentProduct = await repository.show(id: id);
    productSink.add(this._currentProduct);
  }

  void fetchCreditProducts(String filtro) async {
    creditProductListSink.add(ProductList(isLoading: true, list: []));
    ProductList list = await repository.productList(filtro);
    _creditsBloc.setCurrentProductFromList(list);
    creditProductListSink.add(list);
  }

  void fetchParametros(String group) async {
    parametroListSink.add(Parametros(isLoading: true));
    Parametros parametros = await repository.getParametros(group);
    parametroListSink.add(parametros);
  }

  Object productCode(List<Map<String, dynamic>> params) {
    if (params[0]['esferico'] == '') {
      return {
        'data': [
          {
            'codigo': {
              'codigo': params[0]['grupo'] + '000000',
              'cilindrico': null,
              'grau': null,
              'adicao': null
            },
            'olho': params[0]['olho']
          }
        ],
        'success': true
      };
    }
    return repository.productCode(params);
  }

  Future<bool> checkProduct(Map<String, dynamic> params) async {
    return repository.checkProduct(params);
  }

  Future<Map<String, dynamic>> checkProductGrausDiferentes(
      Map<String, dynamic> data, Map<String, dynamic> allowedParams) async {
    return repository.checkProductGrausDiferentes(data, allowedParams);
  }

  BehaviorSubject _parametroList = BehaviorSubject();
  Sink get parametroListSink => _parametroList.sink;
  Stream get parametroListStream => _parametroList.stream;

  BehaviorSubject _creditProductsList = BehaviorSubject();
  Sink get creditProductListSink => _creditProductsList.sink;
  Stream get creditProductListStream => _creditProductsList.stream;

  BehaviorSubject _favoriteProductsList = BehaviorSubject();
  Sink get favoriteProductListSink => _favoriteProductsList.sink;
  Stream get favoriteProductListStream => _favoriteProductsList.stream;
  get favoriteProductListValue => _favoriteProductsList.value;

  StreamController<ProductEvent> _product = BehaviorSubject();
  Sink get productSink => _product.sink;
  Stream<ProductEvent> get productStream => _product.stream;

  StreamController _productRedirected = BehaviorSubject();
  Sink get productRedirectedSink => _productRedirected.sink;
  Stream get productRedirectedStream => _productRedirected.stream;

  void setOffers(ProductModel product) async {
    print('linha 123');
    Offers _offers = await _creditsBloc.fetchCreditOfferSync(product.group);
    _offersRedirected.sink.add(_offers);
  }

  void fetchOffers() async {
    print('linha 128 product bloc');
    // offersRedirectedSink
    //     .add(Offers(isLoading: true, type: "FINAN", isEmpty: true));
    Offers offers = await repository.getOffers();
    offersRedirectedSink.add(offers);
    
    // return offers;
  }

  StreamController _offersRedirected = BehaviorSubject();
  Sink get offersRedirectedSink => _offersRedirected.sink;
  Stream get offersRedirectedStream => _offersRedirected.stream;

  StreamController<ProductEvent> _productsList = BehaviorSubject();
  Sink get productListSink => _productsList.sink;
  Stream<ProductEvent> get productListStream => _productsList.stream;

  @override
  void dispose() {
    _creditProductsList.close();
    _offersRedirected.close();
    _productsList.close();
    _product.close();
    _parametroList.close();
  }
}
