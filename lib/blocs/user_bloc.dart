import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class UserBloc extends Disposable {
  UserRepository repository;

  UserBloc(this.repository);

  BehaviorSubject _currentUserController = BehaviorSubject.seeded(null);
  Sink get currentUserIn => _currentUserController.sink;
  Stream<UserModel> get currentUserOut =>
      _currentUserController.stream.asyncMap(
        (event) => repository.currentUser(),
      );

  @override
  void dispose() {
    _currentUserController.close();
  }
}
