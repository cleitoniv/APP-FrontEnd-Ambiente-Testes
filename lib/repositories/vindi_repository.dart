import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/models/vindi_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

AuthBloc _authBloc = Modular.get<AuthBloc>();

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
  AuthEvent currentUser;
  VindiRepository(this.dio);

  Future<VindiCreditCard> addVindiCreditCard(CreditCardModel model) async {
    this.currentUser = _authBloc.getAuthCurrentUser;
    print('linha 41');
    // inspect(this.currentUser.data);
    print(this.currentUser.data.tokenVindi);
    try {
      Response response = await dio.post(
        "/api/v1/public/payment_profiles",
        options: Options(headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic ${this.currentUser.data.tokenVindi}"
        }),
        data: jsonEncode({
          "card_cvv": model.ccv,
          "card_number": model.cartaoNumber,
          "card_expiration": model.mesValidade + '/' + model.anoValidade,
          "holder_name": model.nomeTitular
        }),
        
      );
      print('linha 59');
      print(response);
      VindiCardModel card =
          VindiCardModel.fromJson(response.data['payment_profile']);
      return VindiCreditCard(isEmpty: false, isLoading: false, cartao: card);
    } catch (error) {
      print('linha 67');
      print(error.message);
      return VindiCreditCard(isEmpty: true, isLoading: false, errorData: {
        "falha": ["Falha ao criar cartão"]
      });
    }
  }
}
