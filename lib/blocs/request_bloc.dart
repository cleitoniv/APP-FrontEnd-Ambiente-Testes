import 'package:central_oftalmica_app_cliente/models/request_details_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class RequestsBloc extends Disposable {
  RequestsRepository repository;

  RequestsBloc(this.repository);

  void getPedido(int id) async {
    pedidoInfoSink.add(Pedido(isLoading: true));
    Pedido pedido = await repository.getPedido(id);
    pedidoInfoSink.add(pedido);
  }

  void fetchPoints() async {
    pointsSink.add(PointsList(isLoading: true));
    PointsList list = await repository.fetchPoints();
    pointsSink.add(list);
  }

  BehaviorSubject _pointsController = BehaviorSubject();
  Sink get pointsSink => _pointsController.sink;
  Stream get pointsStream => _pointsController.stream;

  BehaviorSubject _pedidoInfoController = BehaviorSubject();
  Sink get pedidoInfoSink => _pedidoInfoController.sink;
  Stream get pedidoInfoStream => _pedidoInfoController.stream;

  BehaviorSubject _currentRequestFilter = BehaviorSubject.seeded(0);
  Sink get currentRequestFilterSink => _currentRequestFilter.sink;
  Stream get currentRequestFilterStream => _currentRequestFilter.stream;

  int get currentFilter => _currentRequestFilter.value;

  void getPedidosList(int filtro) async {
    pedidoSink.add(PedidosList(isLoading: true));
    PedidosList list = await repository.getPedidos(filtro);
    pedidoSink.add(list);
  }

  BehaviorSubject _pedidoController = BehaviorSubject();
  Sink get pedidoSink => _pedidoController.sink;
  Stream get pedidoStream => _pedidoController.stream;

  BehaviorSubject _taxaEntregaController = BehaviorSubject();
  Sink get taxaEntregaSink => _taxaEntregaController.sink;
  Stream get taxaEntregaStream => _taxaEntregaController.stream;

  get taxaEntregaValue => _taxaEntregaController.value;

  BehaviorSubject _indexController = BehaviorSubject.seeded(null);
  Sink get indexIn => _indexController.sink;
  Stream<List<RequestModel>> get indexOut => _indexController.stream.asyncMap(
        (event) => repository.index(
          filter: event,
        ),
      );

  BehaviorSubject _showController = BehaviorSubject.seeded(null);
  Sink get showIn => _showController.sink;
  Stream<RequestDetailsModel> get showOut => _showController.stream.asyncMap(
        (event) => repository.show(
          id: event,
        ),
      );

  BehaviorSubject _cartController = BehaviorSubject.seeded(
    <Map<String, dynamic>>[],
  );
  Sink get cartIn => _cartController.sink;
  Stream<List<Map<String, dynamic>>> get cartOut => _cartController.stream.map(
        (event) => event,
      );

  get cartItems => _cartController.value;

  void resetCart() {
    cartIn.add(<Map<String, dynamic>>[]);
  }

  void removeFromCart(data) {
    List<Map<String, dynamic>> itens = _cartController.value;
    List<Map<String, dynamic>> novosItens =
        itens.where((e) => e['_cart_item'] != data['_cart_item']).toList();
    cartIn.add(novosItens);
  }

  addProductToCart(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> _first = await cartOut.first;
    if (_first.isEmpty) {
      _first.add(data);
      cartIn.add(_first);
    } else {
      if (!_first.contains(data)) {
        _first.add(data);
        cartIn.add(_first);
      } else {
        _first.remove(data);
        cartIn.add(_first);
      }
    }
  }

  BehaviorSubject _creditProductCartController = BehaviorSubject();
  Sink get creditCartSink => _creditProductCartController.sink;
  Stream get creditCartStream => _creditProductCartController.stream;

  addCreditProductToCart(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> _first = await creditCartStream.first;
    if (_first.isEmpty) {
      _first.add(data);
      creditCartSink.add(_first);
    } else {
      if (!_first.contains(data)) {
        _first.add(data);
        creditCartSink.add(_first);
      } else {
        _first.remove(data);
        creditCartSink.add(_first);
      }
    }
  }

  @override
  void dispose() {
    _pedidoController.close();
    _cartController.close();
    _showController.close();
    _indexController.close();
  }
}
