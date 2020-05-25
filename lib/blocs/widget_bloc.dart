import 'package:rxdart/subjects.dart';

class WidgetBloc {
  BehaviorSubject _sightProblemController = BehaviorSubject.seeded('Todos');
  Sink get sightProblemIn => _sightProblemController.sink;
  Stream<String> get sightProblemOut => _sightProblemController.stream.map(
        (event) => event,
      );
}
