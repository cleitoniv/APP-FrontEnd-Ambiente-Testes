import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ProductWidgetBloc extends Disposable {
  BehaviorSubject _pacientInfoController = BehaviorSubject.seeded({
    'test': 'Não',
    'current': 'Olho direito',
    'Olho direito': {
      'degree': '',
      'cylinder': '',
      'axis': '',
      'lenses': '',
      'cor': '',
      'adicao': ''
    },
    'Olho esquerdo': {
      'degree': '',
      'cylinder': '',
      'axis': '',
      'lenses': '',
      'cor': '',
      'adicao': ''
    },
    'Mesmo grau em ambos': {
      'degree': '',
      'cylinder': '',
      'axis': '',
      'lenses': '',
      'cor': '',
      'adicao': ''
    },
    'Graus diferentes em cada olho': {
      'esquerdo': {
        'degree': '',
        'cylinder': '',
        'axis': '',
        'lenses': '',
        'cor': '',
        'adicao': ''
      },
      'direito': {
        'degree': '',
        'cylinder': '',
        'axis': '',
        'lenses': '',
        'cor': '',
        'adicao': ''
      }
    },
  });

  void resetPacientInfo() {
    pacientInfoIn.add({
      'test': 'Não',
      'current': 'Olho direito',
      'Olho direito': {
        'degree': '',
        'cylinder': '',
        'axis': '',
        'lenses': '',
        'cor': '',
        'adicao': ''
      },
      'Olho esquerdo': {
        'degree': '',
        'cylinder': '',
        'axis': '',
        'lenses': '',
        'cor': '',
        'adicao': ''
      },
      'Mesmo grau em ambos': {
        'degree': '',
        'cylinder': '',
        'axis': '',
        'lenses': '',
        'cor': '',
        'adicao': ''
      },
      'Graus diferentes em cada olho': {
        'esquerdo': {
          'degree': '',
          'cylinder': '',
          'axis': '',
          'lenses': '',
          'cor': '',
          'adicao': ''
        },
        'direito': {
          'degree': '',
          'cylinder': '',
          'axis': '',
          'lenses': '',
          'cor': '',
          'adicao': ''
        }
      },
    });
  }

  Sink get pacientInfoIn => _pacientInfoController.sink;
  Stream<Map<dynamic, dynamic>> get pacientInfoOut =>
      _pacientInfoController.stream.map(
        (event) => event,
      );

  Map<dynamic, dynamic> get pacientInfo => _pacientInfoController.value;

  BehaviorSubject _showInfoController = BehaviorSubject.seeded(false);
  Sink get showInfoIn => _showInfoController.sink;
  Stream<bool> get showInfoOut => _showInfoController.stream.map(
        (event) => event,
      );

  @override
  void dispose() {
    _pacientInfoController.close();
    _showInfoController.close();
  }
}
