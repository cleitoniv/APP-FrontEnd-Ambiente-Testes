import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ExtractWidgetBloc extends Disposable {
  BehaviorSubject _extractTypeController = BehaviorSubject.seeded('Financeiro');
  Sink get extractTypeIn => _extractTypeController.sink;
  Stream<String> get extractTypeOut => _extractTypeController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _extractTypeController.close();
  }
}
