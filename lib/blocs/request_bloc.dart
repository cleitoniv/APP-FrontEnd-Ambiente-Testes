import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class RequestsBloc extends Disposable {
  RequestsRepository repository;

  RequestsBloc(this.repository);

  BehaviorSubject _indexController = BehaviorSubject.seeded(null);
  Sink get indexIn => _indexController.sink;
  Stream<List<RequestModel>> get indexOut => _indexController.stream.asyncMap(
        (event) => repository.index(
          filter: event,
        ),
      );

  BehaviorSubject _cartController = BehaviorSubject.seeded(
    <Map<String, dynamic>>[],
  );
  Sink get cartIn => _cartController.sink;
  Stream<List<Map<String, dynamic>>> get cartOut => _cartController.stream.map(
        (event) => event,
      );

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

  @override
  void dispose() {
    _cartController.close();
    _indexController.close();
  }
}
