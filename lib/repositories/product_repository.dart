import 'dart:convert';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/devolution_model.dart';
import 'package:central_oftalmica_app_cliente/models/parametro_produto.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductEvent {
  bool isEmpty;
  bool isLoading;
}

class ProductList implements ProductEvent {
  bool isEmpty;
  bool isLoading;
  List<ProductModel> list;
  List<String> filters;

  ProductList({this.isEmpty, this.list, this.isLoading, this.filters});
}

class Product implements ProductEvent {
  bool isEmpty;
  bool isLoading;
  ProductModel product;
  Product({this.isLoading, this.product, this.isEmpty});
}

class Devolution implements ProductEvent {
  bool isEmpty;
  bool isLoading;
  DevolutionModel devolution;
  bool status;
  Devolution({this.isLoading, this.devolution, this.status});
}

class Parametros {
  bool isValid;
  bool isLoading;
  String errorMessage;
  ParametroProdutoModel parametro;

  Parametros({this.isValid, this.errorMessage, this.parametro, this.isLoading});
}

class ProductRepository {
  Dio dio;

  ProductRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc _authBloc = Modular.get<AuthBloc>();

  @override
  Future<String> delete({int id}) {
    throw UnimplementedError();
  }

  Future<bool> checkProduct(Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/verify_graus",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }),
          queryParameters: data);
      return response.data["success"];
    } catch (error) {
      return false;
    }
  }

  Future<Parametros> getParametros(String group) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/get_graus?grupo=${group}",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      ParametroProdutoModel parametro =
          ParametroProdutoModel.fromJson(response.data['data']);
      return Parametros(isValid: true, parametro: parametro, isLoading: false);
    } catch (error) {
      return Parametros(isValid: false, isLoading: false);
    }
  }

  Future<ProductEvent> productList(String filtro) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
          '/api/cliente/produtos?filtro=${filtro}',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));

      List<ProductModel> products = (response.data['data'] as List)
          .map(
            (e) => ProductModel.fromJson(e),
          )
          .toList();

      List<String> filters = response.data['filters'].map<String>((e) {
        return "$e";
      }).toList();

      return ProductList(
          list: products, isEmpty: false, isLoading: false, filters: filters);
    } catch (error) {
      return ProductList(
          list: null, isEmpty: true, isLoading: false, filters: ["Todos"]);
    }
  }

  Future<Product> show({int id}) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try {
      Response response = await dio.get('/api/cliente/product/$id',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      ProductModel product = ProductModel.fromJson(response.data['data']);
      return Product(isEmpty: false, isLoading: false, product: product);
    } catch (error) {
      return Product(isEmpty: true, isLoading: false, product: null);
    }
  }

  Future<Product> getProductBySerie({String serie}) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try {
      Response response = await dio.get('/api/cliente/product_serie/$serie',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      ProductModel product = ProductModel.fromJson(response.data['data']);
      return Product(isEmpty: false, isLoading: false, product: product);
    } catch (error) {
      return Product(isEmpty: true, isLoading: false, product: null);
    }
  }

  Future<Devolution> nextStepDevolution(Map<String, dynamic> params) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.post("/api/cliente/next_step",
          data: jsonEncode(params),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      DevolutionModel devol = DevolutionModel.fromJson(response.data["data"]);

      bool status;

      if (response.data['status'] == "continue") {
        status = true;
      } else {
        status = false;
      }
      return Devolution(isLoading: false, devolution: devol, status: status);
    } catch (error) {
      return Devolution(isLoading: false, status: false);
    }
  }

  void sendEmail(String email) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      await dio.get("/api/cliente/send_email_dev?email=${email}",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
    } catch (error) {}
  }

  Future<Devolution> confirmDevolution(
      ProductList productList, String tipo) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    List<Map<String, dynamic>> products =
        productList.list.map<Map<String, dynamic>>((e) {
      return e.toJson();
    }).toList();

    try {
      Response response = await dio.post('/api/cliente/devolution_continue',
          data: jsonEncode({"products": products, "tipo": tipo}),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${idToken.token}"
          }));
      DevolutionModel devol = DevolutionModel.fromJson(response.data["data"]);
      return Devolution(
          isLoading: false,
          devolution: devol,
          status: response.data["success"]);
    } catch (error) {
      return Devolution(isLoading: false, status: false);
    }
  }

  Future<String> store({ProductModel model}) {
    throw UnimplementedError();
  }

  Future<String> update({int id, ProductModel model}) {
    throw UnimplementedError();
  }
}
