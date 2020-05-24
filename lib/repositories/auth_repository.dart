import 'package:dio/dio.dart';

class AuthRepository {
  Dio dio;

  AuthRepository(this.dio);

  Future login() async {}

  Future signout() async {}

  Future createAccount() async {}

  Future passwordReset() async {}
}
