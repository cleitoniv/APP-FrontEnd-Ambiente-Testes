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
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
        "/api/cliente/payments?filtro=$filtro",
        options: Options(
          headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          },
        ),
      );
      List<PaymentModel> list = response.data["data"].map<PaymentModel>((e) {
        return PaymentModel.fromJson(e);
      }).toList();
      return PaymentsList(
          isLoading: false, isEmpty: list.length <= 0, list: list);
    } catch (error) {
      return PaymentsList(isEmpty: true, isLoading: false);
    }
  }

  Map<String, dynamic> generateParams(Map data, PaymentMethod paymentMethod) {
    List items = data['cart'].map<Map>((e) {
      if (e["operation"] == "01") {
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
              'codigo_teste': e['codigoTeste'],
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests']
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e["operation"] == "13") {
        return {
          'type': e['type'] ,
          'operation': e['tests'] == "Sim" ? "03" : e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['tests'] == "Sim" ? e['product'].valueTest : e['product'].value,
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
          'type': e['tests'] == "Sim" ? "C" : e['type'],
          'operation': e['tests'] == "Sim" ? "03" : e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests']
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e["operation"] == "04") {
        return {
          'type': e['tests'] == "Sim" ? "C" : e['type'],
          'operation': "03",
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['tests'] == "Não"
                  ? e['product'].group
                  : e['product'].groupTest,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests']
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e['operation'] == '03') {
        return {
          'type': e['tests'] == "Sim" ? "C" : e['type'],
          'operation': e['operation'],
          'paciente': {
            'nome': e['pacient']['name'],
            'numero': e['pacient']['number'],
            'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
          },
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'grupo_teste': e['product'].groupTest,
              'produto_teste': e['product'].produtoTeste,
              'produto': e['product'].title,
              'quantidade': e['quantity'],
              'quantity_for_eye': e['quantity_for_eye'],
              'grupo': e['product'].groupTest,
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'duracao': e['product'].duracao,
              'prc_unitario': e['product'].value,
              "valor_test": e['product'].valueTest * 100,
              'tests': e['tests'] ?? 'N'
            }
          ],
          'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
          'olho_direito': e['Olho direito'] ?? null,
          'olho_esquerdo': e['Olho esquerdo'] ?? null,
          'olho_ambos': e['Mesmo grau em ambos'] ?? null
        };
      } else if (e['operation'] == '06' && e['type'] == 'C') {
        return {
          'operation': e['operation'],
          'type': e['tests'] == "Sim" ? "C" : e['type'],
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'percentage_test': e['percentage_test'] ?? 0,
              'produto': e['product'].title,
              'codigo': '${e['product'].group}000000',
              'grupo': e['product'].group,
              'quantidade': e['quantity'],
              'valor_credito_finan': e['product'].valueFinan ?? 0,
              'valor_credito_prod': e['product'].valueProduto ?? 0,
              'prc_unitario': e['product'].value,
              'duracao': e['product'].duracao
            }
          ]
        };
      } else {
        return {
          'operation': e['operation'],
          'type': e['type'],
          'items': [
            { 
              'codigo_teste': e['codigoTeste'],
              'percentage_test': e['percentage_test'],
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
    print('linha 231');
    print(items);
    return {
      'items': items,
      'id_cartao':
          paymentMethod.creditCard != null ? paymentMethod.creditCard.token : 0,
      'installment': data['installment'],
      'taxa_entrega': data['taxa_entrega']
    };
  }

  Future<bool> payment(Map<String, dynamic> data, PaymentMethod paymentMethod,
      bool isBoleto) async {
    Map<String, dynamic> params = generateParams(data, paymentMethod);
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      if (!isBoleto) {
        print(params);
        await dio.post('/api/cliente/pedidos',
            data: jsonEncode(params),
            options: Options(headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $idToken"
            }));
        return true;
      }
      await dio.post('/api/cliente/pedido_boleto',
          data: jsonEncode(params),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      return true;
    } catch (error) {
      return false;
    }
  }
}
