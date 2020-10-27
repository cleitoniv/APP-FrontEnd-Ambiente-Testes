import 'dart:convert';

import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/models/extrato_finan.dart';
import 'package:central_oftalmica_app_cliente/models/extrato_produto.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/points_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Offers {
  bool isLoading;
  bool isEmpty;
  List<OfferModel> offers;

  Offers({this.isEmpty, this.isLoading, this.offers});
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

  ExtratoProduto({this.isLoading, this.isEmpty, this.data});
}

class CreditoPagamento {
  bool success;

  CreditoPagamento({this.success});
}

class CreditsRepository {
  Dio dio;

  CreditsRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ExtratoProduto> fetchExtratoProduto() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/extrato_prod",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      List<ExtratoProdutoModel> extrato =
          response.data["data"].map<ExtratoProdutoModel>((e) {
        return ExtratoProdutoModel.fromJson(e);
      }).toList();
      return ExtratoProduto(
          data: extrato, isEmpty: extrato.length <= 0, isLoading: false);
    } catch (error) {
      return ExtratoProduto(isEmpty: true, isLoading: false);
    }
  }

  Future<ExtratoFinanceiro> fetchExtrato() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/extrato_finan",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      ExtratoFinanceiroModel extrato =
          ExtratoFinanceiroModel.fromJson(response.data["data"]);
      return ExtratoFinanceiro(
          isLoading: false,
          isEmpty: extrato.data.length <= 0,
          financeiro: extrato);
    } catch (error) {
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

  Future<CreditoPagamento> creditoFinanceiroPagamento(
      CreditoFinanceiro credito, int cartaoId) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.post(
          '/api/cliente/pedido/credito_financeiro',
          data: jsonEncode({
            "items": [
              {
                "valor": credito.valor,
                "desconto": credito.desconto,
                "prestacoes": credito.installmentCount
              }
            ],
            "id_cartao": cartaoId
          }),
          options:
              Options(headers: {"Authorization": "Bearer ${idToken.token}"}));
      return CreditoPagamento(success: true);
    } catch (error) {
      return CreditoPagamento(success: false);
    }
  }

  Future<Offers> getOffers() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/offers',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      final offers = response.data['data'].map<OfferModel>((e) {
        return OfferModel.fromJson(e);
      }).toList();
      return Offers(isLoading: false, isEmpty: false, offers: offers);
    } catch (error) {
      return Offers(isLoading: false, isEmpty: true, offers: null);
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
