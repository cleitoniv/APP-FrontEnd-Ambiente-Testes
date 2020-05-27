import 'package:rxdart/subjects.dart';

class ProfileBloc {
  BehaviorSubject _visitHourController = BehaviorSubject.seeded('Manhã');
  Sink get visitHourIn => _visitHourController.sink;
  Stream<String> get visitHourOut => _visitHourController.stream.map(
        (event) => event,
      );

  BehaviorSubject _securityShowPasswordController =
      BehaviorSubject.seeded(true);
  Sink get securityShowPasswordIn => _securityShowPasswordController.sink;
  Stream<bool> get securityShowPasswordOut =>
      _securityShowPasswordController.stream.map(
        (event) => event,
      );
}
