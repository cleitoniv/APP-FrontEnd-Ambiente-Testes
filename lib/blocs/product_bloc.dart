import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc {
  ProductRepository repository;

  ProductBloc(this.repository);

  Product _currentProduct;

  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();

  Product get currentProduct => this._currentProduct;

  void setCurrentProduct(Product product) {
    this._currentProduct = product;
  }

  void fetchProducts(String filtro) async {
    productListSink.add(ProductList(isEmpty: true, isLoading: true));
    ProductList list = await repository.productList(filtro);
    productListSink.add(list);
  }

  void fetchProduct(int id) async {
    productSink.add(Product(isLoading: true));
    this._currentProduct = await repository.show(id: id);
    productSink.add(this._currentProduct);
  }

  void fetchCreditProducts(String filtro) async {
    creditProductListSink.add(ProductList(isLoading: true));
    ProductList list = await repository.productList(filtro);
    _creditsBloc.setCurrentProductFromList(list);
    creditProductListSink.add(list);
  }

  void fetchParametros(String group) async {
    parametroListSink.add(Parametros(isLoading: true));
    Parametros parametros = await repository.getParametros(group);
    parametroListSink.add(parametros);
  }

  Future<bool> checkProduct(Map<String, dynamic> params) async {
    return repository.checkProduct(params);
  }

  BehaviorSubject _parametroList = BehaviorSubject();
  Sink get parametroListSink => _parametroList.sink;
  Stream get parametroListStream => _parametroList.stream;

  BehaviorSubject _creditProductsList = BehaviorSubject();
  Sink get creditProductListSink => _creditProductsList.sink;
  Stream get creditProductListStream => _creditProductsList.stream;

  StreamController<ProductEvent> _product = BehaviorSubject();
  Sink get productSink => _product.sink;
  Stream<ProductEvent> get productStream => _product.stream;

  StreamController<ProductEvent> _productsList = BehaviorSubject();
  Sink get productListSink => _productsList.sink;
  Stream<ProductEvent> get productListStream => _productsList.stream;

  @override
  Sink get destroyIn => throw UnimplementedError();

  @override
  Stream<String> get destroyOut => throw UnimplementedError();

  BehaviorSubject _showController = BehaviorSubject.seeded(null);
  @override
  Sink get showIn => _showController.sink;

  @override
  Sink get storeIn => throw UnimplementedError();

  @override
  Stream<String> get storeOut => throw UnimplementedError();

  @override
  Sink get updateIn => throw UnimplementedError();

  @override
  Stream<String> get updateOut => throw UnimplementedError();

  @override
  void dispose() {
    _creditProductsList.close();
    _productsList.close();
    _product.close();
    _showController.close();
  }
}
