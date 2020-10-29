import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/cadastro_model.dart';
import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
import 'package:central_oftalmica_app_cliente/models/endereco.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class Authentication {
  bool isValid;
  bool loading;
}

class LoginEvent implements Authentication {
  String message;
  bool isValid;
  bool loading;
  AuthResult result;
  Map<String, dynamic> errorData;
  LoginEvent({this.message, this.isValid, this.errorData, this.result});
}

class AuthEvent implements Authentication {
  ClienteModel data;
  bool isValid;
  AuthEvent({this.data, this.isValid, this.loading});
  bool loading;
}

class Cadastro {
  bool isLoading;
  bool isEmpty;
  CadastroModel dados;

  Cadastro({this.isLoading, this.isEmpty, this.dados});
}

class Endereco {
  bool isLoading;
  bool isEmpty;
  EnderecoModel endereco;

  Endereco({this.isEmpty, this.isLoading, this.endereco});
}

class AuthRepository {
  Dio dio;
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();

  AuthRepository(this.dio);

  Future<Endereco> getEnderecoByCep(String cep) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.get(
          "/api/cliente/get_endereco_by_cep?cep=${cep}",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 200 && response.data["success"]) {
        EnderecoModel endereco = EnderecoModel.fromJson(response.data["data"]);
        return Endereco(isLoading: false, isEmpty: false, endereco: endereco);
      }
    } catch (error) {
      return Endereco(isLoading: false, isEmpty: false);
    }
  }

  Future<Cadastro> getDados(String cnpj) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/protheus/${cnpj}",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": ""
          }));
      if (response.data["success"]) {
        CadastroModel cadastro = CadastroModel.fromJson(response.data["data"]);
        return Cadastro(isLoading: false, isEmpty: false, dados: cadastro);
      } else {
        return Cadastro(isLoading: false, isEmpty: true);
      }
    } catch (error) {
      return Cadastro(isEmpty: true, isLoading: false);
    }
  }

  Future<LoginEvent> login({
    String email,
    String password,
  }) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return LoginEvent(message: "OK", isValid: true, result: result);
    } catch (error) {
      return LoginEvent(message: "Credenciais Inválidas.", isValid: false);
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

  Future<LoginEvent> firstAccess(Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();
    try {
      Response response = await dio.post('/api/cliente/first_access',
          data: jsonEncode({"param": data}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      print(response.data);
      return LoginEvent(message: "OK", isValid: true);
    } catch (error) {
      final error400 = error as DioError;
      print(error400.response);
      return LoginEvent(
          message: "Ocorreu um problema com o seu cadastro",
          isValid: false,
          errorData: error400.response.data['data']['errors']);
    }
  }

  Future<LoginEvent> createAccount(Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.post('/api/cliente',
          data: jsonEncode({"param": data}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      return LoginEvent(message: "OK", isValid: true);
    } catch (error) {
      final error400 = error as DioError;
      return LoginEvent(
          message: "Ocorreu um problema com o seu cadastro",
          isValid: false,
          errorData: error400.response.data['data']['errors']);
    }
  }

  Future<AuthEvent> currentUser(LoginEvent login) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try {
      Response resp = await dio.get("/api/cliente/current_user",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      ClienteModel cliente = ClienteModel.fromJson(resp.data);
      if (cliente.sitApp == "N" || cliente.sitApp == "E") {
        return AuthEvent(isValid: false, data: cliente, loading: true);
      } else {
        return AuthEvent(isValid: true, data: cliente, loading: false);
      }
    } catch (error) {
      return AuthEvent(isValid: false, data: null, loading: true);
    }
  }

  Future<void> passwordReset({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
    } catch (error) {
      return null;
    }
  }

  Future<String> updatePassword({String password}) async {
    try {
      FirebaseUser _user = await _auth.currentUser();

      await _user.updatePassword(password);

      return '';
    } catch (error) {
      return error.code;
    }
  }
}
