import 'package:rxdart/subjects.dart';

class AuthWidgetBloc {
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
}
