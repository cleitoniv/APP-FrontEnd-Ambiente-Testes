import 'package:central_oftalmica_app_cliente/models/pedido_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_details_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class RequestsBloc extends Disposable {
  RequestsRepository repository;

  RequestsBloc(this.repository);

  void getPedido(String id, PedidoModel pedidoData, bool reposicao) async {
    pedidoInfoSink.add(Pedido(isLoading: true));
    Pedido pedido =
        await repository.getPedido(id, pedidoData, reposicao: reposicao);
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

  void getPedidosRepoList(int filtro) async {
    pedidoReposicaoSink.add(PedidosList(isLoading: true));
    PedidosList list = await repository.getPedidos(filtro);
    pedidoReposicaoSink.add(list);
  }

  void getPedidosList(int filtro) async {
    print('meu filtro:');
    print(filtro);
    pedidoSink.add(PedidosList(isLoading: true));
    PedidosList list = await repository.getPedidos(filtro);
    pedidoSink.add(list);
  }

  BehaviorSubject _pedidoController = BehaviorSubject();
  Sink get pedidoSink => _pedidoController.sink;
  Stream get pedidoStream => _pedidoController.stream;

  BehaviorSubject _pedidoReposicaoController = BehaviorSubject();
  Sink get pedidoReposicaoSink => _pedidoReposicaoController.sink;
  Stream get pedidoReposicaoStream => _pedidoReposicaoController.stream;

  BehaviorSubject _taxaEntregaController = BehaviorSubject();
  Sink get taxaEntregaSink => _taxaEntregaController.sink;
  Stream get taxaEntregaStream => _taxaEntregaController.stream;

  get taxaEntregaValue => _taxaEntregaController.value;
  get taxaEntregaHasValue => _taxaEntregaController.hasValue;
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

  Future<OrderPayment> orderPayment(List<Map<String, dynamic>> _data) async {
    return repository.orderPayment(_data);
  }

  void removeFromCart(data) {
    List<Map<String, dynamic>> itens = _cartController.value;
    List<Map<String, dynamic>> novosItens =
        itens.where((e) => e['_cart_item'] != data['_cart_item']).toList();
    cartIn.add(novosItens);
  }

  Object checkStock(Map<dynamic, dynamic> params) {
    var codigo = params['itens'].keys.elementAt(0);
    var corte = codigo.substring(4, 10);
    if (corte == '000000') {
      return {
        'data': {
          'index': [1],
          'itens': [
            {
              'adicao': '',
              'cilindro': '',
              'codigo': codigo,
              'cor': '',
              'descricao': 'Este produto não existe',
              'eixo': '',
              'grau': '',
              'prazo': '',
              'saldo': 0
            }
          ],
          'pendencia': false,
          'prazo': 0
        },
        'success': true
      };
    } else
      return repository.checkStock(params);
  }

  addProductToCart(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> _first = await cartOut.first;
    Map<String, dynamic> _newData = {...data};

    if (data['operation'] == "07" && data["tests"] == "Sim" ||
        data['operation'] == "01" && data["tests"] == "Sim" ||
        data['operation'] == "13" && data["tests"] == "Sim") {
      _newData["removeItem"] = 'Não';
      data['removeItem'] = 'Sim';
      data["tests"] = "Não";

      if (_newData['operation'] == "01" && _newData["tests"] == "Sim") {
        _newData["operation"] = "04";
      }

      if (_first.isEmpty) {
        _first.add(_newData);
        cartIn.add(_first);
      } else {
        if (!_first.contains(data)) {
          _first.add(_newData);
          cartIn.add(_first);
        } else {
          _first.remove(_newData);
          cartIn.add(_first);
        }
      }
    }

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
    _creditProductCartController.close();
    _pedidoController.close();
    _cartController.close();
    _showController.close();
    _indexController.close();
    _pointsController.close();
    _pedidoInfoController.close();
    _currentRequestFilter.close();
    _taxaEntregaController.close();
  }
}
