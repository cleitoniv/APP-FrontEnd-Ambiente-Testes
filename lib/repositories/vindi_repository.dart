import 'dart:convert';

import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VindiCreditCardEvent {
  bool isLoading;
  bool isEmpty;
}

class VindiCreditCard implements VindiCreditCardEvent {
  bool isLoading;
  bool isEmpty;
  Map<String, dynamic> errorData;
  VindiCardModel cartao;
  VindiCreditCard({this.isEmpty, this.isLoading, this.cartao, this.errorData});
}

class VindiCardList implements VindiCreditCardEvent {
  bool isLoading;
  bool isEmpty;
  List<CreditCardModel> list;
  VindiCardList({this.isEmpty, this.isLoading, this.list});
}

class VindiRepository {
  Dio dio;

  VindiRepository(this.dio);

  Future<VindiCreditCard> addVindiCreditCard(CreditCardModel model) async {
    try {
      Response response = await dio.post(
        "/api/v1/public/payment_profiles",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Basic SXdZYlhtdkhqSm1rdHBkVGNmT0Nfa29qb25ReG5wY2dQaVUzOUtReDdyWTo="
        }),
        data: jsonEncode({
          "card_number": model.cartaoNumber,
          "card_expiration": model.mesValidade + '/' + model.anoValidade,
          "holder_name": model.nomeTitular
        }),
      );
      VindiCardModel card =
          VindiCardModel.fromJson(response.data['payment_profile']);
      return VindiCreditCard(isEmpty: false, isLoading: false, cartao: card);
    } catch (error) {
      return VindiCreditCard(isEmpty: true, isLoading: false, errorData: {
        "falha": ["Falha ao criar cartão"]
      });
    }
  }
}
