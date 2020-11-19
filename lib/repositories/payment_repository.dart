import 'dart:convert';

import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/payments_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentsList {
  bool isLoading;
  bool isEmpty;
  List<PaymentModel> list;

  PaymentsList({this.isEmpty, this.isLoading, this.list});
}

class PaymentRepository {
  Dio dio;

  PaymentRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  String parseDtNascimento(String dtNascimento) {
    try {
      List dtSplited = dtNascimento.split("/");
      return "${dtSplited[2]}-${dtSplited[1]}-${dtSplited[0]}";
    } catch (error) {
      return null;
    }
  }

  Future<PaymentsList> fetchPayments(String filtro) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
          "/api/cliente/payments?filtro=${filtro}",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      List<PaymentModel> list = response.data["data"].map<PaymentModel>((e) {
        print(e);
        return PaymentModel.fromJson(e);
      }).toList();
      return PaymentsList(
          isLoading: false, isEmpty: list.length <= 0, list: list);
    } catch (error) {
      return PaymentsList(isEmpty: true, isLoading: false);
    }
  }

  Map<String, dynamic> generate_params(Map data, PaymentMethod paymentMethod) {
    List items = data['cart'].map<Map>((e) {
      if (e["operation"] == "01" ||
          e["operation"] == "13" ||
          e["operation"] == "07") {
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
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['product'].group,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              'tests': e['tests']
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
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'prc_unitario': e['product'].value,
              'duracao': e['product'].duracao
            }
          ]
        };
      }
    }).toList();
    return {
      'items': items,
      'id_cartao':
          paymentMethod.creditCard != null ? paymentMethod.creditCard.id : 0,
      'ccv': data['ccv'],
      'installment': data['installment'],
      'taxa_entrega': data['taxa_entrega']
    };
  }

  Future<bool> payment(Map<String, dynamic> data, PaymentMethod paymentMethod,
      bool isBoleto) async {
    Map<String, dynamic> params = generate_params(data, paymentMethod);
    print(params);
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try {
      if (!isBoleto) {
        Response response = await dio.post('/api/cliente/pedidos',
            data: jsonEncode(params),
            options: Options(headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${idToken.token}"
            }));

        return true;
      }
      Response response = await dio.post('/api/cliente/pedido_boleto',
          data: jsonEncode(params),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      return true;
    } catch (error) {
      print('...............................');
      final error400 = error as DioError;
      print(error400.response.data);
      print(error);
      return false;
    }
  }
}
