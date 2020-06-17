import 'package:rxdart/subjects.dart';

class ExtractWidgetBloc {
  BehaviorSubject _extractTypeController = BehaviorSubject.seeded('Financeiro');
  Sink get extractTypeIn => _extractTypeController.sink;
  Stream<String> get extractTypeOut => _extractTypeController.stream.map(
        (event) => event,
      );
}
