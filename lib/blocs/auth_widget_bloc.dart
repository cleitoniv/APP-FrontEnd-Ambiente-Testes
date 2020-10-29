import 'dart:math';

import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class AuthWidgetBloc extends Disposable {
  AuthResult _guestToken;
  AuthRepository repository;
  AuthWidgetBloc({this.repository});

  FirebaseAuth _auth = FirebaseAuth.instance;

  void setAuthResult(AuthResult auth) {
    this._guestToken = auth;
  }

  AuthResult getGuestToken() {
    return _guestToken;
  }

  BehaviorSubject _createAccountShowPasswordController =
      BehaviorSubject.seeded(true);
  Sink get createAccountShowPasswordIn =>
      _createAccountShowPasswordController.sink;
  Stream<bool> get createAccountShowPasswordOut =>
      _createAccountShowPasswordController.stream.map(
        (event) => event,
      );

  BehaviorSubject _createAccountTermController = BehaviorSubject.seeded(false);
  Sink get createAccountTermIn => _createAccountTermController.sink;
  Stream<bool> get createAccountTermOut =>
      _createAccountTermController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentActivityController = BehaviorSubject.seeded(null);
  Sink get currentActivityIn => _currentActivityController.sink;
  Stream<Map<String, dynamic>> get currentActivityOut =>
      _currentActivityController.stream.map(
        (event) => event,
      );

  BehaviorSubject _loginShowPasswordController = BehaviorSubject.seeded(true);
  Sink get loginShowPasswordIn => _loginShowPasswordController.sink;
  Stream<bool> get loginShowPasswordOut =>
      _loginShowPasswordController.stream.map(
        (event) => event,
      );

  BehaviorSubject _createAccountDataController = BehaviorSubject.seeded(null);
  Sink get createAccountDataIn => _createAccountDataController.sink;
  Stream<Map<String, dynamic>> get createAccountDataOut =>
      _createAccountDataController.stream.map(
        (event) => event,
      );
  Map<String, dynamic> get currentAccountData =>
      _createAccountDataController.value;

  Future<String> registerGuestToken(Map<String, dynamic> data) async {
    try {
      if (this._guestToken != null) {
        return "ok";
      } else {
        this._guestToken = await _auth.createUserWithEmailAndPassword(
          email: data['email'],
          password: data['password'],
        );

        Map<String, dynamic> _first = await createAccountDataOut.first;

        if (_first == null) {
          createAccountDataIn.add(data);
        } else {
          createAccountDataIn.add({
            ..._first,
            ...data,
          });
        }
        return "ok";
      }
    } catch (e) {
      final error = e as PlatformException;
      return error.code;
    }
  }

  addUserInfo(Map<String, dynamic> data) async {
    Map<String, dynamic> _first = await createAccountDataOut.first;

    if (_first == null) {
      createAccountDataIn.add(data);
    } else {
      createAccountDataIn.add({
        ..._first,
        ...data,
      });
    }
  }

  Future<bool> confirmSms(int code, int phone) async {
    bool codeMatch = await repository.checkCode(code, phone);
    return codeMatch;
  }

  Future<bool> requireCodeSms(int phone) async {
    bool codeMatch = await repository.requireCode(phone);
    return codeMatch;
  }

  @override
  void dispose() {
    _createAccountShowPasswordController.close();
    _createAccountTermController.close();
    _currentActivityController.close();
    _loginShowPasswordController.close();
    _createAccountDataController.close();
  }
}
