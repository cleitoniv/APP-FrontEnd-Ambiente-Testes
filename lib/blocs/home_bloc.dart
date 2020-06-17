import 'package:rxdart/rxdart.dart';

class HomeBloc {
  BehaviorSubject _sightProblemController = BehaviorSubject.seeded('Todos');
  Sink get sightProblemIn => _sightProblemController.sink;
  Stream<String> get sightProblemOut => _sightProblemController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentCreditTypeController =
      BehaviorSubject.seeded('Financeiro');
  Sink get currentCreditTypeIn => _currentCreditTypeController.sink;
  Stream<String> get currentCreditTypeOut =>
      _currentCreditTypeController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentRequestTypeController =
      BehaviorSubject.seeded('Pendentes');
  Sink get currentRequestTypeIn => _currentRequestTypeController.sink;
  Stream<String> get currentRequestTypeOut =>
      _currentRequestTypeController.stream.map(
        (event) => event,
      );

  BehaviorSubject _currentTabIndexController = BehaviorSubject.seeded(0);
  Sink get currentTabIndexIn => _currentTabIndexController.sink;
  Stream<int> get currentTabIndexOut => _currentTabIndexController.stream.map(
        (event) => event,
      );
}
