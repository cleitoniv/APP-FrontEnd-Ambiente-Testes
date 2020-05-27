import 'package:rxdart/subjects.dart';

class IntroWidgetBloc {
  BehaviorSubject _currentSlideController = BehaviorSubject.seeded(0);
  Sink get currentSlideIn => _currentSlideController.sink;
  Stream<int> get currentSlideOut => _currentSlideController.stream.map(
        (event) => event,
      );
}
