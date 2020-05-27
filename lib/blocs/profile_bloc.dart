import 'package:rxdart/subjects.dart';

class ProfileBloc {
  BehaviorSubject _visitHourController = BehaviorSubject.seeded('Manhã');
  Sink get visitHourIn => _visitHourController.sink;
  Stream<String> get visitHourOut => _visitHourController.stream.map(
        (event) => event,
      );
}
