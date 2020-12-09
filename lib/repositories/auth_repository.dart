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

class AcceptTerms {
  List<String> data;
  bool isEmpty;
  bool isLoading;
  AcceptTerms({this.data, this.isEmpty, this.isLoading});
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
  Map<String, dynamic> errorData;
  bool isValid;
  bool integrated;
  AuthEvent(
      {this.data,
      this.integrated = false,
      this.isValid,
      this.loading,
      this.errorData});
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

class ResetPassword {
  bool isLoading;
  bool canReset;
  Map<String, dynamic> errorData;

  ResetPassword({this.isLoading, this.canReset, this.errorData});
}

class AuthRepository {
  Dio dio;
  FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<AcceptTerms> getTermsOfResponsability() async {
    try {
      final response = await dio.get('/api/termo_responsabilidade');
      List<String> responseTerm =
          (response.data["data"] as List).map<String>((e) => e).toList();
      return AcceptTerms(data: responseTerm, isEmpty: false, isLoading: false);
    } catch (e) {
      return AcceptTerms(isLoading: false, isEmpty: true);
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

      return LoginEvent(message: "OK", isValid: true);
    } catch (error) {
      final error400 = error as DioError;
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

Future<int> currentUserStatus() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();
    try { 
      Response resp = await dio.get("/api/cliente/current_user",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
           
          return resp.data["status"]; 
      
    } catch (error) { 
      print(error);
      return 0;
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

      if (cliente.sitApp == "A" || cliente.sitApp == "E") {
        return AuthEvent(
            isValid: true, data: cliente, loading: false, integrated: false);
      } else if (cliente.sitApp == "N" || cliente.sitApp == "I") {
        return AuthEvent(
            isValid: false,
            integrated: true,
            data: cliente,
            loading: true,
            errorData: {
              "Cadastro": [
                "Erro no seu cadastro. Entre em contato com a Central Oftalmica."
              ]
            });
      } else {
        return AuthEvent(isValid: true, data: cliente, loading: false);
      }
    } catch (error) {
      final error400 = error as DioError;
      print(error400.response.data);
      return AuthEvent(isValid: false, data: null, loading: true, errorData: {
        "Cadastro": [error400.response.data['data']]
      });
    }
  }

  Future<ResetPassword> checkUserEmail(String email) async {
    try {
      Response resp = await dio.post("/api/verify_email",
          data: jsonEncode({"email": email}));
      print(resp.data);
      return ResetPassword(canReset: resp.data['success'], isLoading: false);
    } catch (error) {
      final error400 = error as DioError;
      print(error400.response);
      return ResetPassword(
          canReset: false,
          isLoading: true,
          errorData: error400.response.data['data']['errors']);
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
      print(error);
      return error.code;
    }
  }

  Future<bool> checkCode(int code, int phone) async {
    try {
      Response response = await dio.get(
        "/api/confirmation_code?code_sms=${code}&phone_number=55${phone}",
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      bool matchStatus = response.data["success"];
      return matchStatus;
    } catch (error) {
      return false;
    }
  }

  Future<bool> requireCode(int phone) async {
    try {
      Response response = await dio.get(
        "/api/send_sms?phone_number=55${phone}",
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      bool matchStatus = response.data["success"];
      return matchStatus;
    } catch (error) {
      return false;
    }
  }
}
