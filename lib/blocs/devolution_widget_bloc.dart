import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class DevolutionWidgetBloc extends Disposable {
  BehaviorSubject _devolutionTypeController = BehaviorSubject.seeded('Crédito');
  Sink get devolutionTypeIn => _devolutionTypeController.sink;
  Stream<String> get devolutionTypeOut => _devolutionTypeController.stream.map(
        (event) => event,
      );

  BehaviorSubject _productParamsController = BehaviorSubject.seeded({
    'degree': null,
    'cylinder': null,
    'axis': null,
    'color': null,
    'addition': null,
  });
  Sink get productParamsIn => _productParamsController.sink;
  Stream<Map<String, dynamic>> get productParamsOut =>
      _productParamsController.stream.map(
        (event) => event,
      );

  BehaviorSubject _buttonCartStatusController = BehaviorSubject.seeded(false);
  Sink get buttonCartStatusIn => _buttonCartStatusController.sink;
  Stream<bool> get buttonCartStatusOut =>
      _buttonCartStatusController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _devolutionTypeController.close();
    _productParamsController.close();
    _buttonCartStatusController.close();
  }
}
