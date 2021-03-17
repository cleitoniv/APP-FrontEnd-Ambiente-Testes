import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ProfileWidgetBloc extends Disposable {
  UserRepository repository;

  ProfileWidgetBloc({this.repository});

  BehaviorSubject _visitHourController = BehaviorSubject.seeded('Manhã');
  Sink get visitHourIn => _visitHourController.sink;
  Stream<String> get visitHourOut => _visitHourController.stream.map(
        (event) => event,
      );

  Future<AtendPref> updateVisitHour(String hour) async {
    return repository.updateAtendPref(hour);
  }

  BehaviorSubject _updateVisitHourController = BehaviorSubject();
  Sink get updateVisitHourSink => _updateVisitHourController.sink;
  Stream get updateVisitHourStream => _updateVisitHourController.stream;

  String get currentVisitHour => _visitHourController.value;

  BehaviorSubject _securityShowPasswordController =
      BehaviorSubject.seeded(true);
  Sink get securityShowPasswordIn => _securityShowPasswordController.sink;
  Stream<bool> get securityShowPasswordOut =>
      _securityShowPasswordController.stream.map(
        (event) => event,
      );

  BehaviorSubject _userStatusController = BehaviorSubject.seeded(true);
  Sink get userStatusIn => _userStatusController.sink;
  Stream<bool> get userStatusOut => _userStatusController.stream.map(
        (event) => event,
      );
  get currentStatus => _userStatusController.value;

  @override
  void dispose() {
    _visitHourController.close();
    _securityShowPasswordController.close();
    _userStatusController.close();
    _updateVisitHourController.close();
  }
}
