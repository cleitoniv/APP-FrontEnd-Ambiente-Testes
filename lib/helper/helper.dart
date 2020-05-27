import 'package:intl/intl.dart';

class Helper {
  static String lengthValidator(
    String text, {
    int length = 0,
    String message = 'Campo inválido',
  }) {
    if (text.isEmpty || text.length < length) {
      return message;
    }

    return null;
  }

  static String emailValidator(String text) {
    if (text.isEmpty || text.indexOf('@') == -1 || text.indexOf('.') == -1) {
      return 'Email inválido';
    }

    return null;
  }

  static String equalValidator(
    String text, {
    String value,
    String message = 'Campos não coincidem',
  }) {
    if (text != value) {
      return message;
    }
    return null;
  }

  static intToMoney(int value) {
    return '${NumberFormat('#,##0.00', 'pt_BR').format(value / 100)}';
  }

  static moneyToInt(double value) {
    return int.parse(
      value.toString().replaceAll(',', '.').replaceAll('.', ''),
    );
  }
}
