import 'dart:convert';
import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/devolution_model.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/parametro_produto.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
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

  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkProduct(Map<String, dynamic> data) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    data.remove("codigo");
    try {
      Response response = await dio.get("/api/cliente/verify_graus",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }),
          queryParameters: data);
      return response.data["success"];
    } catch (error) {
      return false;
    }
  }

  Future<Map> productCode(List<Map<String, dynamic>> data) async {
    print('linha 81');
    print(data);
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.patch("/api/cliente/product_code",
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }),
          data: jsonEncode({"lens": data}));
          print('linha 92');
          print(data);
      return response.data;
    } catch (error) {
      print('linha 96');
      print(error.response);
      return {'success': false};
    }
  }

  Future<List> favorites(AuthEvent currentUser) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.get(
          '/api/cliente/favorite?user_id=${currentUser.data.id}&page=1&page_size=1000',
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $idToken"
            },
          ));
      return response.data["data"];
    } catch (error) {
      return [];
    }
  }

  Future<Offers> getOffers() async {
    var modPag =  _cartWidgetBloc.currentPaymentFormValue;
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get('/api/cliente/offers',
          queryParameters: modPag == null 
          ? {} 
          : {
            "modpag": modPag.isBoleto ? 'B' : 'C'
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );
      final offers = response.data['data'].map<OfferModel>((e) {
        return OfferModel.fromJson(e);
      }).toList();
      inspect(offers);
      return Offers(
          isLoading: false, isEmpty: false, offers: offers, type: "FINAN");
    } catch (error) {
      // inspect(error);
      print(error);
      print('passando pelo catch linha 136');
      return Offers(
          isLoading: false, isEmpty: true, offers: null, type: "FINAN");
    }
  }

  Future<bool> favorite(String group) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    var currentUser = _authBloc.getAuthCurrentUser;

    try {
      Response response = await dio.post(
        "/api/cliente/favorite",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
        data: jsonEncode(
          {
            "param": {"group": group, "user_id": currentUser.data.id}
          },
        ),
      );
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<Map<String, dynamic>> checkProductGrausDiferentes(
      Map<String, dynamic> data, Map<String, dynamic> allowedParams) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      await dio.post(
        "/api/cliente/verify_graus",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
        data: jsonEncode(
          {
            "param": {
              "data": data,
              "allowed_params": allowedParams,
            }
          },
        ),
      );
      return {};
    } catch (error) {
      final error400 = error as DioError;
      return error400.response.data['data']['errors'];
    }
  }

  Future<Parametros> getParametros(String group) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.get(
        "/api/cliente/get_graus?grupo=$group",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );
      ParametroProdutoModel parametro =
          ParametroProdutoModel.fromJson(response.data['data']);
      return Parametros(isValid: true, parametro: parametro, isLoading: false);
    } catch (error) {
      return Parametros(isValid: false, isLoading: false);
    }
  }

  Future<ProductEvent> productList(String filtro) async {
    User user = await _auth.currentUser;
    String idToken = await user.getIdToken();
    print('filtro utilizado');
    print(filtro);
    try {
      Response response = await dio.get(
        '/api/cliente/produtos?filtro=$filtro',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

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
          list: [], isEmpty: true, isLoading: false, filters: ["Todos"]);
    }
  }

  Future<Product> show({int id}) async {
    User user = await _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.get('/api/cliente/product/$id',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      ProductModel product = ProductModel.fromJson(response.data['data']);
      return Product(isEmpty: false, isLoading: false, product: product);
    } catch (error) {
      return Product(isEmpty: true, isLoading: false, product: null);
    }
  }

  Future<Product> getProductBySerie({String serie}) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();
    try {
      Response response = await dio.get('/api/cliente/product_serie/$serie',
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          }));
      ProductModel product = ProductModel.fromJson(response.data['data']);
      return Product(
          isEmpty: response.data['data'].length > 0 ? false : true,
          isLoading: false,
          product: product);
    } catch (error) {
      return Product(isEmpty: true, isLoading: false, product: null);
    }
  }

  Future<Devolution> nextStepDevolution(Map<String, dynamic> params) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      Response response = await dio.post("/api/cliente/next_step",
          data: jsonEncode(params),
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
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
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    try {
      await dio.get(
        "/api/cliente/send_email_dev?email=$email",
        options: Options(
          headers: {
            "Authorization": "Bearer $idToken",
            "Content-Type": "application/json"
          },
        ),
      );
    } catch (error) {}
  }

  Future<Devolution> confirmDevolution(
      ProductList productList, String tipo) async {
    User user = _auth.currentUser;
    String idToken = await user.getIdToken();

    List<Map<String, dynamic>> products =
        productList.list.map<Map<String, dynamic>>((e) {
      return e.toJson();
    }).toList();
    try {
      Response response = await dio.post(
        '/api/cliente/devolution_continue',
        data: jsonEncode({"products": products, "tipo": tipo}),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      DevolutionModel devol;

      if (tipo != "C") {
        devol = DevolutionModel.fromJson(response.data["data"]);
        return Devolution(
            isLoading: false,
            devolution: devol,
            status: response.data["success"]);
      }
      return Devolution(
          isLoading: false, devolution: null, status: response.data["success"]);
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
