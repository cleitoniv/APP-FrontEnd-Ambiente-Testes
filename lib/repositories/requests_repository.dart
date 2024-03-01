import 'dart:convert';
import 'dart:developer';

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

class OrderPayment {
  bool isLoading;
  bool isValid;
  Map<String, dynamic> error;

  OrderPayment({this.isLoading, this.isValid, this.error});
}

class RequestsRepository {
  Dio dio;

  FirebaseAuth _auth = FirebaseAuth.instance;

  RequestsRepository(this.dio);

  String parseDtNascimento(String dtNascimento) {
    try {
      List dtSplited = dtNascimento.split("/");
      return "${dtSplited[2]}-${dtSplited[1]}-${dtSplited[0]}";
    } catch (error) {
      return null;
    }
  }

  Map<String, dynamic> generateParams(Map data) {
    print('linha 60');
    print(data['cart']);
    List items = data['cart'].map<Map>((e) {
      if (e["operation"] == "01" || e["operation"] == "13") {
        return {
          'type': e['type'],
          'operation': e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            {
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'duracao': e['product'].duracao,
              'prc_unitario': e['tests'] == "Não" ? e['product'].value : 0,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests']
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e["operation"] == "07") {
        return {
          'type': e['type'],
          'operation': e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            {
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'duracao': e['product'].duracao,
              'prc_unitario': e['tests'] == "Não" ? e['product'].value : 0,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests']
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e["operation"] == "03") {
        return {
          'type': e['type'],
          'operation': e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            {
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['product'].groupTest,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              "valor_test": e['product'].valueTest * 100,
              'tests': 'Sim',
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e["operation"] == "04") {
        return {
          'type': e['type'],
          'operation': e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            {
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['product'].groupTest,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              "valor_test": e['product'].valueTest * 100,
              'tests': 'Sim',
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else {
        return {
          'operation': e['operation'],
          'type': e['type'],
          'items': [
            {
              'produto': e['product'].title,
              'codigo': e['product'].produto,
              'grupo': e['product'].group,
              'quantidade': e['quantity'],
              'prc_unitario': e['product'].value,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              "valor_test": e['product'].valueTest * 100,
              'duracao': e['product'].duracao
            }
          ]
        };
      }
    }).toList();
    return {'items': items, 'valor': 0};
  }

  Future<Map<dynamic, dynamic>> checkStock(Map<dynamic, dynamic> params) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.post('/api/cliente/check_stock_found',
          data: jsonEncode(params),
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          }));
      return response.data;
    } catch (e) {
      return {"success": false};
    }
  }

  Future<OrderPayment> orderPayment(List<Map<String, dynamic>> _data) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.post('/api/cliente/pedido_produto',
          data: jsonEncode(generateParams({'cart': _data})),
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          }));
      print('linha 231');
      print(response.data);
      return OrderPayment(isValid: response.data["success"], isLoading: false);
    } catch (e) {
      final error400 = e as DioException;
      return OrderPayment(isValid: false, isLoading: false, error: {
        "Pedido": [error400.response.data["data"]]
      });
    }
  }

  Future<PointsList> fetchPoints() async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/points',
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
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

  Future<Pedido> getPedido(int id, PedidoModel pedidoData,
      {bool reposicao = false}) async {
    print('linha 265');
    inspect(pedidoData);
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
        '/api/cliente/pedido/$id',
        queryParameters: {
          "data_nascimento": pedidoData.dataNascimento,
          "nome": pedidoData.paciente,
          "reposicao": reposicao
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          },
        ),
      );

      PedidoModel pedido = PedidoModel.fromJson(response.data['data']);
      return Pedido(isEmpty: false, isLoading: false, pedido: pedido);
    } catch (error) {
      return Pedido(isEmpty: true, isLoading: false, pedido: null);
    }
  }

  Future<PedidosList> getPedidos(int filtro) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
        '/api/cliente/detail_order?filtro=$filtro',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      List<PedidoModel> pedidos = response.data['data'].map<PedidoModel>((e) {
        return PedidoModel.fromJson(e);
      }).toList();

      return PedidosList(
          isEmpty: pedidos.length <= 0, isLoading: false, list: pedidos);
    } catch (error) {
      return PedidosList(isEmpty: true, isLoading: false, list: null);
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
