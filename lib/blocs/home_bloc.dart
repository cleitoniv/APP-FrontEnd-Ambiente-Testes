import 'package:rxdart/rxdart.dart';

class HomeBloc {
  BehaviorSubject _sightProblemController = BehaviorSubject.seeded('Todos');
  Sink get sightProblemIn => _sightProblemController.sink;
  Stream<String> get sightProblemOut => _sightProblemController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentTabIndexController = BehaviorSubject.seeded(0);
  Sink get currentTabIndexIn => _currentTabIndexController.sink;
  Stream<int> get currentTabIndexOut => _currentTabIndexController.stream.map(
        (event) => event,
      );
}
