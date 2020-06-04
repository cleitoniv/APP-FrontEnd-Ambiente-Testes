import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc extends Disposable {
  AuthRepository repository;

  AuthBloc(this.repository);

  BehaviorSubject _loginController = BehaviorSubject.seeded(null);
  Sink get loginIn => _loginController.sink;
  Stream<String> get loginOut => _loginController.stream.asyncMap(
        (event) => repository.login(
          email: event['email'],
          password: event['password'],
        ),
      );

  BehaviorSubject _createAccountController = BehaviorSubject.seeded(null);
  Sink get createAccountIn => _createAccountController.sink;
  Stream<String> get createAccountOut =>
      _createAccountController.stream.asyncMap(
        (event) => repository.createAccount(
          event,
        ),
      );

  BehaviorSubject _passwordResetController = BehaviorSubject.seeded(null);
  Sink get passwordResetIn => _passwordResetController.sink;
  Stream<void> get passwordResetOut => _passwordResetController.stream.asyncMap(
        (event) => repository.passwordReset(
          email: event,
        ),
      );

  BehaviorSubject _signOutController = BehaviorSubject.seeded(null);
  Sink get signOutIn => _signOutController.sink;
  Stream<void> get signOutOut => _signOutController.stream.asyncMap(
        (event) => repository.signout(),
      );

  @override
  void dispose() {
    _loginController.close();
    _createAccountController.close();
    _passwordResetController.close();
    _signOutController.close();
  }
}
