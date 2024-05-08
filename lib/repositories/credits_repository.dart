import 'dart:convert';
import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/models/extrato_finan.dart';
import 'package:central_oftalmica_app_cliente/models/extrato_produto.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../blocs/cart_widget_bloc.dart';

class Offers {
  bool isLoading;
  bool isEmpty;
  List<OfferModel> offers;
  String type;

  Offers({this.isEmpty, this.isLoading, this.offers, this.type});
}

class OffersProduct {
  bool isLoading;
  bool isEmpty;
  List<OfferModel> offers;
  String type;

  OffersProduct({this.isEmpty, this.isLoading, this.offers, this.type});
}

class ExtratoFinanceiro {
  bool isLoading;
  bool isEmpty;
  ExtratoFinanceiroModel financeiro;

  ExtratoFinanceiro({this.isEmpty, this.isLoading, this.financeiro});
}

class ExtratoProduto {
  bool isLoading;
  bool isEmpty;
  List<ExtratoProdutoModel> data;
  String date;

  ExtratoProduto({this.date, this.isLoading, this.isEmpty, this.data});
}

class CreditoPagamento {
  bool success;

  CreditoPagamento({this.success});
}

class CreditsRepository {
  Dio dio;

  CreditsRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

  Future<ExtratoProduto> fetchExtratoProduto() async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/extrato_prod",
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          }));
      List<ExtratoProdutoModel> extrato =
          response.data["data"].map<ExtratoProdutoModel>((e) {
        return ExtratoProdutoModel.fromJson(e);
      }).toList();
      return ExtratoProduto(
          data: extrato,
          isEmpty: extrato.length <= 0,
          isLoading: false,
          date: response.data['date']);
    } catch (error) {
      return ExtratoProduto(isEmpty: true, isLoading: false);
    }
  }

  Future<ExtratoFinanceiro> fetchExtrato() async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/extrato_finan",
          options: Options(headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          }));
      ExtratoFinanceiroModel extrato =
          ExtratoFinanceiroModel.fromJson(response.data["data"]);
      print('linha 101');
      inspect(extrato);
      return ExtratoFinanceiro(
          isLoading: false,
          isEmpty: extrato.data.length <= 0,
          financeiro: extrato);
    } catch (error) {
      inspect(error);
      return ExtratoFinanceiro(isLoading: false, isEmpty: true);
    }
  }

  Future<FinancialCreditModel> indexFinancial() async {
    try {
      Response response = await dio.get(
        '/financialCredits',
      );

      return FinancialCreditModel.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }

  Future<ProductCreditModel> indexProduct() async {
    try {
      Response response = await dio.get(
        '/productCredits',
      );

      return ProductCreditModel.fromJson(response.data);
    } catch (error) {
      return null;
    }
  }

  Future<bool> creditoFinanceiroPagamento(
      CreditoFinanceiro credito, String token, bool isBoleto) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      await dio.post(
        '/api/cliente/pedido/credito_financeiro',
        data: jsonEncode(
          {
            "items": [
              {
                "valor": credito.valor,
                "desconto": credito.desconto,
                "prestacoes": credito.installmentCount
              }
            ],
            "id_cartao": token
          },
        ),
        options: Options(
          headers: {"Authorization": "Bearer $idToken"},
        ),
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<Offers> getOffers() async {
    // var modPag =  await _cartWidgetBloc.currentPaymentFormValue;
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/offers',
          // queryParameters: modPag == null 
          // ? {} 
          // : {
          //   "modpag": modPag.isBoleto ? 'B' : 'C'
          // },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      print('retorno do crfi');
      print(response.data);
      final offers = response.data['data'].map<OfferModel>((e) {
        return OfferModel.fromJson(e);
      }).toList();
      return Offers(
          isLoading: false, isEmpty: false, offers: offers, type: "FINAN");
    } catch (error) {
      return Offers(
          isLoading: false, isEmpty: true, offers: null, type: "FINAN");
    }
  }

  Future<Offers> getAvulseOffers() async {
    var modPag = await _cartWidgetBloc.currentPaymentFormValue;
    print(modPag.isBoleto);
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/avulso_offers',
          queryParameters: modPag == null 
          ? {} 
          : {
            "modpag": modPag.isBoleto ? 'B' : 'C'
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      final offers = response.data['data'].map<OfferModel>((e) {
        return OfferModel.fromJson(e);
      }).toList();

      // print(offers);
      // inspect(offers);
      return Offers(
          isLoading: false, isEmpty: false, offers: offers, type: "Avulse");
    } catch (error) {
      return Offers(
          isLoading: false, isEmpty: true, offers: null, type: "Avulse");
    }
  }

  Future<Offers> getOffersCreditProduct(String group) async {
    // var modPag = await _cartWidgetBloc.currentPaymentFormValue;
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/get_pacote',
          queryParameters: 
          //modPag == null ? {
          //   "grupo": group
          // } : 
          {
            "grupo": group,
            // "modpag": modPag.isBoleto ? 'B' : 'C'
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      final offers = response.data['data'].map<OfferModel>((e) {
        return OfferModel.fromJson(e);
      }).toList();
      // print('linha 185');
      // inspect(offers);
      // print(offers);
      return Offers(
          isLoading: false, isEmpty: false, offers: offers, type: "CREDIT");
    } catch (error) {
      return Offers(
          isLoading: false, isEmpty: true, offers: null, type: "CREDIT");
    }
  }

  Future<String> storeFinancial(int value) async {
    try {
      Response response = await dio.post(
        '/financialCredits',
        data: jsonEncode({
          'value': value,
        }),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }
}
