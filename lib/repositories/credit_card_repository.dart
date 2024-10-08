import 'dart:convert';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthBloc _authBloc = Modular.get<AuthBloc>();

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
  List<VindiCardModel> list;
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
  AuthEvent currentUser;
  CreditCardRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<RemoveCard> removeCard(int id) async {
    print('linha 50');
    print(id);
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
      print('linha 64');
      print(e);
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
            "gateway_token": model.token,
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

    this.currentUser = _authBloc.getAuthCurrentUser;
    // ignore: unused_local_variable
    String code = this.currentUser.data.codigo + this.currentUser.data.loja;

    try {
      Response response = await dio.get('/api/cliente/cards',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      List<VindiCardModel> cards = response.data['data']
          .map<VindiCardModel>(
            (e) => VindiCardModel.fromJson(e),
          )
          .toList();
      print('linha 129');
      print(response.data['data'].length);
      // return Future.delayed(const Duration(seconds: 2), () {
      return CreditCardList(
          isEmpty: cards.length == 0, isLoading: false, list: cards);
      // });
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
    print('linha 169');
    print(isBoleto);
    print(valor);
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
      print('linha 194');
      print(response.data['data']);
      return response.data['data'];
    } catch (error) {
      print('linha 196');
      print(error);
      return null;
    }
  }
}
