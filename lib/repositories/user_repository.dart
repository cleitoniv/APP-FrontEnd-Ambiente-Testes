import 'dart:convert';
import 'package:central_oftalmica_app_cliente/models/endereco_entrega.dart';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/models/usuario_cliente.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PointsResult {
  bool isValid;
  bool isLoading;
  int credits;
  int points;
  PointsResult({this.isValid, this.credits, this.isLoading, this.points});
}

class AtendPref {
  bool isLoading;
  bool isValid;

  AtendPref({this.isLoading, this.isValid});
}

class Endereco {
  bool isLoading;
  bool isEmpty;
  EnderecoEntregaModel endereco;
  Endereco({this.isLoading, this.isEmpty, this.endereco});
}

class UsuarioClienteList {
  bool isLoading;
  bool isEmpty;
  List<UsuarioClienteModel> usuarios;

  UsuarioClienteList({this.isLoading, this.isEmpty, this.usuarios});
}

class AddUsuarioCliente {
  bool isValid;
  Map<String, dynamic> data;
  String errorMessage;

  AddUsuarioCliente({this.isValid, this.data, this.errorMessage});
}

class UpdateUsuarioCliente {
  bool isValid;
  String errorMessage;
  Map<String, dynamic> data;

  UpdateUsuarioCliente({this.isValid, this.data, this.errorMessage});
}

class DeleteUsuarioCliente {
  bool isValid;
  String errorMessage;
  Map<String, dynamic> data;

  DeleteUsuarioCliente({this.isValid, this.data, this.errorMessage});
}

class UserRepository {
  Dio dio;

  FirebaseAuth _auth = FirebaseAuth.instance;

  UserRepository(this.dio);

  Future<UpdateUsuarioCliente> updateUsuarioCliente(
      int id, Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.put("/api/usuarios_cliente/$id",
          data: jsonEncode({"param": data}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 200) {
        return UpdateUsuarioCliente(isValid: true, data: response.data);
      } else {
        return UpdateUsuarioCliente(
            isValid: false, errorMessage: "Erro na atualizacao do cliente.");
      }
    } catch (error) {
      return UpdateUsuarioCliente(
          isValid: false, errorMessage: "Erro na atualizacao do cliente.");
    }
  }

  Future<DeleteUsuarioCliente> deleteUsuarioCliente(int id) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.delete("/api/usuarios_cliente/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 200) {
        return DeleteUsuarioCliente(isValid: true);
      } else {
        return DeleteUsuarioCliente(
            isValid: false, errorMessage: "Erro na exclusão do cliente.");
      }
    } catch (error) {
      return DeleteUsuarioCliente(
          isValid: false, errorMessage: "Erro na exclusão do cliente.");
    }
  }

  Future<AddUsuarioCliente> addUsuarioCliente(Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();
    try {
      Response response = await dio.post("/api/cliente/cliente_user",
          data: jsonEncode({"param": data}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));
      if (response.statusCode == 201) {
        return AddUsuarioCliente(isValid: true, data: response.data["data"]);
      } else {
        return AddUsuarioCliente(
            isValid: false,
            errorMessage: "Erro no cadastro. Talvez o email esteja duplicado");
      }
    } catch (error) {
      final error400 = error as DioError;
      print(error400.response.data);
      final message = error400.response.data['errors'];
      return AddUsuarioCliente(
          isValid: false,
          errorMessage: message["EMAIL"] != null
              ? message["EMAIL"][0]
              : "Falha ao salvar dados.");
    }
  }

  Future<UsuarioClienteList> getUsuarios() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.get(
          "/api/usuarios_cliente?page=1&page_size=1000",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      List<UsuarioClienteModel> usuarios =
          response.data["data"].map<UsuarioClienteModel>((e) {
        return UsuarioClienteModel.fromJson(e);
      }).toList();
      return UsuarioClienteList(
          isLoading: false, isEmpty: usuarios.length <= 0, usuarios: usuarios);
    } catch (error) {
      return UsuarioClienteList(isLoading: false, isEmpty: true);
    }
  }

  Future<Endereco> enderecoEntrega() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/endereco_entrega",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      EnderecoEntregaModel endereco =
          EnderecoEntregaModel.fromJson(response.data['data']);
      return Endereco(isEmpty: false, isLoading: false, endereco: endereco);
    } catch (error) {
      return Endereco(isEmpty: true, isLoading: false);
    }
  }

  Future<PointsResult> rescuePoints(int points, credits) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.post(
          "/api/cliente/rescue_points?points=${points}&credit_finan=${credits}",
          data: jsonEncode({}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      return PointsResult(isValid: response.data["success"]);
    } catch (error) {
      return PointsResult(isValid: false);
    }
  }

  Future<PointsResult> convertPoints(int points) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.get(
          "/api/cliente/convert_points?points=${points}",
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      int credits = response.data["data"]["credit_finan"];
      return PointsResult(
          isValid: true, credits: credits, isLoading: false, points: points);
    } catch (error) {
      return PointsResult(isValid: false, isLoading: false);
    }
  }

  Future<PointsResult> addPoints(Map<String, dynamic> data) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.post('/api/cliente/add_points',
          data: jsonEncode({'param': data}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      if (response.data['success']) {
        return PointsResult(isValid: true);
      } else {
        return PointsResult(isValid: false);
      }
    } catch (error) {
      return PointsResult(isValid: false);
    }
  }

  Future<AtendPref> updateAtendPref(String hour) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult token = await user.getIdToken();

    try {
      Response response = await dio.post("/api/cliente/atend_pref",
          data: jsonEncode({"horario": hour}),
          options: Options(headers: {
            "Authorization": "Bearer ${token.token}",
            "Content-Type": "application/json"
          }));

      if (response.data["success"]) {
        return AtendPref(isValid: true);
      } else {
        return AtendPref(isValid: false);
      }
    } catch (error) {
      return AtendPref(isValid: false);
    }
  }

  Future<UserModel> currentUser() async {
    try {
      Response response = await dio.get(
        '/currentUser',
      );

      return UserModel.fromJson(
        response.data,
      );
    } catch (error) {
      return null;
    }
  }

  Future<String> update(
    Map<String, dynamic> data,
  ) async {
    try {
      Response response = await dio.put(
        '/currentUser',
        data: jsonEncode(data),
      );

      return response.data;
    } catch (error) {
      return null;
    }
  }

  Future<String> postPoints(
    Map<String, dynamic> data,
  ) async {
    try {
      Response response = await dio.post(
        '/points',
        data: jsonEncode(data),
      );

      return response.data['data'];
    } catch (error) {
      return null;
    }
  }
}
