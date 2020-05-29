import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class AuthWidgetBloc extends Disposable {
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

  @override
  void dispose() {
    _createAccountShowPasswordController.close();
    _createAccountTermController.close();
    _currentActivityController.close();
  }
}
