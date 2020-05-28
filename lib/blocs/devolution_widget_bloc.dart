import 'package:rxdart/subjects.dart';

class DevolutionWidgetBloc {
  BehaviorSubject _devolutionTypeController = BehaviorSubject.seeded('Crédito');
  Sink get devolutionTypeIn => _devolutionTypeController.sink;
  Stream<String> get devolutionTypeOut => _devolutionTypeController.stream.map(
        (event) => event,
      );
}
