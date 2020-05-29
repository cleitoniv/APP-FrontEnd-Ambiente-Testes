import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ProductWidgetBloc extends Disposable {
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
  Stream<Map<dynamic, dynamic>> get pacientInfoOut =>
      _pacientInfoController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _pacientInfoController.close();
  }
}
