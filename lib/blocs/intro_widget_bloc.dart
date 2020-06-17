import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class IntroWidgetBloc extends Disposable {
  BehaviorSubject _currentSlideController = BehaviorSubject.seeded(0);
  Sink get currentSlideIn => _currentSlideController.sink;
  Stream<int> get currentSlideOut => _currentSlideController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _currentSlideController.close();
  }
}
