import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Dio dio;
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepository(this.dio);

  Future<String> login({
    String email,
    String password,
  }) async {
    try {
      AuthResult _result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseUser _user = _result.user;

      return _user.uid;
    } catch (error) {
      return error.code;
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (error) {
      return null;
    }
  }

  Future<String> createAccount(Map<String, dynamic> data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      Response response = await dio.post(
        '/createAccount',
        data: jsonEncode(data),
      );

      return response.data['data'];
    } catch (error) {
      return error.code;
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
