import 'package:central_oftalmica_app_cliente/models/pedido_model.dart';
import 'package:central_oftalmica_app_cliente/models/points_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_details_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PedidosList {
  bool isEmpty;
  bool isLoading;
  List<PedidoModel> list;

  PedidosList({this.isEmpty, this.isLoading, this.list});
}

class Pedido {
  bool isEmpty;
  bool isLoading;
  PedidoModel pedido;
  Pedido({this.isEmpty, this.isLoading, this.pedido});
}

class PointsList {
  bool isLoading;
  bool isEmpty;

  List<PointsModel> list;

  PointsList({this.isEmpty, this.isLoading, this.list});
}

class RequestsRepository {
  Dio dio;

  FirebaseAuth _auth = FirebaseAuth.instance;

  RequestsRepository(this.dio);

  Future<PointsList> fetchPoints() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/points',
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      List<PointsModel> list =
          response.data['data']['pedidos'].map<PointsModel>((e) {
        return PointsModel.fromJson(e);
      }).toList();
      return PointsList(
          isEmpty: list.length <= 0, isLoading: false, list: list);
    } catch (error) {
      return PointsList(isEmpty: true, isLoading: false);
    }
  }

  Future<Pedido> getPedido(int id) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/pedido/${id}',
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));

      PedidoModel pedido = PedidoModel.fromJson(response.data['data']);
      return Pedido(isEmpty: false, isLoading: false, pedido: pedido);
    } catch (error) {
      return Pedido(isEmpty: true, isLoading: false, pedido: null);
    }
  }

  Future<PedidosList> getPedidos(int filtro) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try {
      Response response = await dio.get(
          '/api/cliente/detail_order?filtro=${filtro}',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));

      List<PedidoModel> pedidos = response.data['data'].map<PedidoModel>((e) {
        return PedidoModel.fromJson(e);
      }).toList();

      return PedidosList(
          isEmpty: pedidos.length <= 0, isLoading: false, list: pedidos);
    } catch (error) {
      return PedidosList(isEmpty: false, isLoading: true, list: null);
    }
  }

  Future<List<RequestModel>> index({
    Map<String, dynamic> filter,
  }) async {
    try {
      Response response = await dio.get(
        '/requests',
        queryParameters: filter,
      );

      return (response.data as List)
          .map(
            (e) => RequestModel.fromJson(e),
          )
          .toList();
    } catch (error) {
      return null;
    }
  }

  Future<RequestDetailsModel> show({int id}) async {
    try {
      Response response = await dio.get(
        '/requests/$id/details',
      );

      return RequestDetailsModel.fromJson(
        response.data,
      );
    } catch (error) {
      return null;
    }
  }
}
