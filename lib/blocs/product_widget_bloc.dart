import 'package:rxdart/subjects.dart';

class ProductWidgetBloc {
  BehaviorSubject _pacientInfoController = BehaviorSubject.seeded({
    //both, left, right, different
    'current': 'Olho direito',
    'Olho direito': {
      'degree': 1.0,
      'cylinder': 1.0,
      'axis': 1.0,
      'lenses': 1.0,
    },
    'Olho esquerdo': {
      'degree': 1.0,
      'cylinder': 1.0,
      'axis': 1.0,
      'lenses': 1.0,
    },
    'Mesmo grau em ambos': {
      'degree': 1.0,
      'cylinder': 1.0,
      'axis': 1.0,
      'lenses': 1.0,
    },
    'Grau diferente em cada olho': {
      'esquerdo': {
        'degree': 1.0,
        'cylinder': 1.0,
        'axis': 1.0,
        'lenses': 1.0,
      },
      'direito': {
        'degree': 1.0,
        'cylinder': 1.0,
        'axis': 1.0,
        'lenses': 1.0,
      }
    },
  });

  Sink get pacientInfoIn => _pacientInfoController.sink;
  Stream<Map<String, dynamic>> get pacientInfoOut =>
      _pacientInfoController.stream.map(
        (event) => event,
      );
}
