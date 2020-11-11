import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc extends Disposable {
  Dio dio;

  AuthRepository repository;

  LoginEvent login;

  AuthBloc(this.repository);

  AuthEvent _currentUser;

  BehaviorSubject _loginController = BehaviorSubject.seeded(null);

  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();

  bool acceptTerms = false;
  BehaviorSubject _accetpTerms = BehaviorSubject();
  Sink get acceptTermSink => _accetpTerms.sink;
  Stream get getTermsOfResponsabilityStream => _accetpTerms.stream;

  Future<Cadastro> fetchCadastro(String cnpj) async {
    return repository.getDados(cnpj);
  }

  void getEnderecoCep(String cep) async {
    Endereco endereco = await repository.getEnderecoByCep(cep);
    enderecoSink.add(endereco);
  }

  acceptTerm() {
    this.acceptTerms = !this.acceptTerms;
  }

  bool acceptTermGetter() {
    return acceptTerms;
  }

  void getTermsOfResponsability() async {
    _accetpTerms.add(AcceptTerms(isLoading: true));
    final response = await repository.getTermsOfResponsability();
    print(response);
    _accetpTerms.add(response);
  }

  BehaviorSubject _cadastroController = BehaviorSubject();
  Sink get cadastroSink => _cadastroController.sink;
  Stream get cadastroStream => _cadastroController.stream;

  BehaviorSubject _enderecoController = BehaviorSubject();
  Sink get enderecoSink => _enderecoController.sink;
  Stream get enderecoStream => _enderecoController.stream;

  Sink get loginIn => _loginController.sink;

  Future<AuthEvent> getCurrentUser(LoginEvent login) async {
    return repository.currentUser(login);
  }

  AuthEvent get getAuthCurrentUser => this._currentUser;

  void setLoginEvent(LoginEvent login) => this.login = login;

  void fetchCurrentUser() async {
    this.clienteDataSink.add(AuthEvent(loading: true));
    this._currentUser = await repository.currentUser(this.login);
    this.clienteDataSink.add(this._currentUser);
  }

  Stream<LoginEvent> get loginOut =>
      _loginController.stream.asyncMap((event) => repository.login(
            email: event['email'],
            password: event['password'],
          ));

  BehaviorSubject _createAccountController = BehaviorSubject.seeded(null);

  Sink get createAccountIn => _createAccountController.sink;

  Stream<LoginEvent> get createAccountOut =>
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

  BehaviorSubject _updatePasswordController = BehaviorSubject.seeded(null);

  Sink get updatePasswordIn => _updatePasswordController.sink;

  Stream<String> get updatePasswordOut =>
      _updatePasswordController.stream.asyncMap(
        (event) => repository.updatePassword(
          password: event,
        ),
      );

  Future<LoginEvent> firstAccess(Map<String, dynamic> data) async {
    return repository.firstAccess(data);
  }

  BehaviorSubject _clienteDataController = BehaviorSubject();

  Sink get clienteDataSink => _clienteDataController.sink;

  Stream get clienteDataStream => _clienteDataController.stream;

  @override
  void dispose() {
    _enderecoController.close();
    _cadastroController.close();
    _clienteDataController.close();
    _loginController.close();
    _createAccountController.close();
    _passwordResetController.close();
    _updatePasswordController.close();
    _signOutController.close();
    _accetpTerms.close();
  }
}
