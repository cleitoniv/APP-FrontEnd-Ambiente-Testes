import 'dart:convert';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Dio dio;

  UserRepository(this.dio);

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
