import 'dart:convert';

import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreditCardEvent {
  bool isLoading;
  bool isEmpty;
}

class CreditCard implements CreditCardEvent {
  bool isLoading;
  bool isEmpty;
  Map<String, dynamic> errorData;
  CreditCardModel cartao;
  CreditCard({this.isEmpty, this.isLoading, this.cartao, this.errorData});
}

class CreditCardList implements CreditCardEvent {
  bool isLoading;
  bool isEmpty;
  List<CreditCardModel> list;
  CreditCardList({this.isEmpty, this.isLoading, this.list});
}

class RemoveCard {
  bool isLoading;
  bool isEmpty;
  bool success;

  String message;
  RemoveCard({this.isEmpty, this.isLoading, this.message, this.success});
}

class CreditCardRepository {
  Dio dio;

  CreditCardRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<RemoveCard> removeCard(int id) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.delete("/api/cliente/card_delete/$id",
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          }));
      return RemoveCard(
          success: response.data["success"],
          message: "Cartão removido com sucesso!");
    } catch (e) {
      return RemoveCard(success: false, message: "Falha ao remover cartão");
    }
  }

  Future<bool> selectCreditCard(int id) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.put('/api/cliente/select_card/$id',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      return response.data["success"];
    } catch (error) {
      return false;
    }
  }

  Future<CreditCard> addCreditCard(CreditCardModel model) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.post(
        "/api/cliente/card",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        }),
        data: jsonEncode({
          'param': {
            "cartao_number": model.cartaoNumber,
            "nome_titular": model.nomeTitular,
            "mes_validade": model.mesValidade,
            "ano_validade": model.anoValidade
          }
        }),
      );

      CreditCardModel card = CreditCardModel.fromJson(response.data['data']);

      return CreditCard(isEmpty: false, isLoading: false, cartao: card);
    } catch (error) {
      return CreditCard(isEmpty: true, isLoading: false, errorData: {
        "falha": ["Falha ao criar cartão"]
      });
    }
  }

  Future<CreditCardList> index() async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/cards',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      List<CreditCardModel> cards = (response.data as List)
          .map(
            (e) => CreditCardModel.fromJson(e),
          )
          .toList();
      cards.sort((a, b) => -a.id.compareTo(b.id));
      return CreditCardList(
          isEmpty: cards.length == 0, isLoading: false, list: cards);
    } catch (error) {
      return CreditCardList(isEmpty: true, isLoading: false, list: []);
    }
  }

  Future<String> store({CreditCardModel model}) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.post(
        "/api/cliente/card",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        }),
        data: jsonEncode({
          'param': {
            "cartao_number": model.cartaoNumber,
            "nome_titular": model.nomeTitular,
            "mes_validade": model.mesValidade,
            "ano_validade": model.anoValidade
          }
        }),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }

  Future<List> fetchInstallments(int valor, bool isBoleto) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      if (isBoleto) {
        Response response = await dio.get(
          "/api/cliente/generate_boleto?valor=$valor",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }),
        );

        return response.data['data'];
      }
      Response response = await dio.get(
        "/api/cliente/taxa?valor=$valor",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken"
        }),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }
}
