import 'dart:async';

import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class HomeWidgetBloc extends Disposable {
  BehaviorSubject _sightProblemController = BehaviorSubject.seeded('Todos');
  Sink get sightProblemIn => _sightProblemController.sink;
  Stream<String> get sightProblemOut => _sightProblemController.stream.map(
        (event) => event,
      );

  get currentSightProblem => _sightProblemController.value;

  BehaviorSubject _currentCreditTypeController =
      BehaviorSubject.seeded('Financeiro');
  Sink get currentCreditTypeIn => _currentCreditTypeController.sink;
  Stream<String> get currentCreditTypeOut =>
      _currentCreditTypeController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentRequestTypeController =
      BehaviorSubject.seeded('Pendentes');
  Sink get currentRequestTypeIn => _currentRequestTypeController.sink;
  Stream<String> get currentRequestTypeOut =>
      _currentRequestTypeController.stream.map(
        (event) => event,
      );
  get currentRequestType => _currentRequestTypeController.value;

  BehaviorSubject _currentTabIndexController = BehaviorSubject.seeded(0);
  Sink get currentTabIndexIn => _currentTabIndexController.sink;
  Stream<int> get currentTabIndexOut => _currentTabIndexController.stream.map(
        (event) => event,
      );

  BehaviorSubject _valueVisibilityController = BehaviorSubject.seeded(false);

  Sink get valueVisibilityIn => _valueVisibilityController.sink;
  Stream<bool> get valueVisibilityOut => _valueVisibilityController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _sightProblemController.close();
    _currentCreditTypeController.close();
    _currentRequestTypeController.close();
    _currentTabIndexController.close();
    _valueVisibilityController.close();
  }
}
