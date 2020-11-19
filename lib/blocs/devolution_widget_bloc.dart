import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class DevolutionWidgetBloc extends Disposable {
  ProductList productsPreDevolucao =
      ProductList(isEmpty: true, list: [], isLoading: false);

  int currentProductIndex = 0;

  String tipoTroca = "C";

  void setTipoTroca(String tipo) {
    if (tipo == "Crédito") {
      this.tipoTroca = "C";
    } else {
      this.tipoTroca = "T";
    }
  }

  void sendEmail(String email) async {
    repository.sendEmail(email);
  }

  ProductRepository repository;

  DevolutionWidgetBloc({this.repository});

  set updateCurrentproductIndex(int index) => this.currentProductIndex = index;

  void fetchProducts(String filtro) async {
    productsListSink.add(ProductList(isEmpty: true, isLoading: true));
  }

  void resetPreDevolucao() async {
    this.productsPreDevolucao =
        ProductList(isEmpty: true, list: [], isLoading: false);
    productsListSink.add(this.productsPreDevolucao);
  }

  void addProduct(String serie) async {
    productsListSink.add(ProductList(isLoading: true, isEmpty: false));
    Product product = await repository.getProductBySerie(serie: serie);

    if (product.product != null &&
        product.product.valid != null &&
        product.product.valid) {
      productErrorAddSink.add({"message": null});
      this.productsPreDevolucao.list.add(product.product);
      //
    } else if (product.isEmpty) {
      productErrorAddSink.add({"message": 'Produto Inexistente!'});
      //
    } else if (product.product != null &&
        product.product.valid != null &&
        !product.product.valid) {
      productErrorSink.add({"message": product.product.message});
      //
    }

    this.productsPreDevolucao.isEmpty =
        this.productsPreDevolucao.list.length <= 0;
    productsListSink.add(this.productsPreDevolucao);
  }

  void confirmDevolution() async {
    Devolution devol = await repository.confirmDevolution(
        this.productsPreDevolucao, this.tipoTroca);
    if (devol.status) {
      currentDevolutionSink.add(devol);
      Modular.to.pushNamed("/devolution/confirm");
    }
  }

  Future<Devolution> nextStepDevolution(Map<String, dynamic> params) async {
    currentDevolutionSink.add(Devolution(isLoading: true));
    return repository.nextStepDevolution(params);
  }

  BehaviorSubject _productError = BehaviorSubject();
  Sink get productErrorSink => _productError.sink;
  Stream get productErrorStream => _productError.stream;

  BehaviorSubject _productErrorAdd = BehaviorSubject();
  Sink get productErrorAddSink => _productErrorAdd.sink;
  Stream get productErrorAddStream => _productErrorAdd.stream;
  get productError => _productErrorAdd.value;

  BehaviorSubject _devolutionController = BehaviorSubject();
  Sink get currentDevolutionSink => _devolutionController.sink;
  Stream get currentDevolutionStream => _devolutionController.stream;

  BehaviorSubject _currentProductController = BehaviorSubject();
  Sink get currentProductSink => _currentProductController.sink;
  Stream get currentProductStream => _currentProductController.stream;

  BehaviorSubject _devolutionTypeController = BehaviorSubject.seeded('Crédito');
  Sink get devolutionTypeIn => _devolutionTypeController.sink;
  Stream<String> get devolutionTypeOut => _devolutionTypeController.stream.map(
        (event) => event,
      );

  BehaviorSubject _parametroList = BehaviorSubject();
  Sink get parametroListSink => _parametroList.sink;
  Stream get parametroListStream => _parametroList.stream;
  void fetchParametros(String group) async {
    parametroListSink.add(Parametros(isLoading: true));
    Parametros parametros = await repository.getParametros(group);
    parametroListSink.add(parametros);
  }

  BehaviorSubject _productParamsController = BehaviorSubject.seeded({
    'esferico': null,
    'cilindrico': null,
    'eixo': null,
    'color': null,
    'adicao': null,
  });
  Sink get productParamsIn => _productParamsController.sink;
  Stream<Map<String, dynamic>> get productParamsOut =>
      _productParamsController.stream.map(
        (event) => event,
      );

  BehaviorSubject _buttonCartStatusController = BehaviorSubject.seeded(false);
  Sink get buttonCartStatusIn => _buttonCartStatusController.sink;
  Stream<bool> get buttonCartStatusOut =>
      _buttonCartStatusController.stream.map(
        (event) => event,
      );

  BehaviorSubject _productsListController = BehaviorSubject();
  Sink get productsListSink => _productsListController.sink;
  Stream get productsListStream => _productsListController.stream;

  ProductList get currentProductList => _productsListController.value;

  @override
  void dispose() {
    _productError.close();
    _productsListController.close();
    _devolutionController.close();
    _productsListController.close();
    _devolutionTypeController.close();
    _productParamsController.close();
    _buttonCartStatusController.close();
  }
}
