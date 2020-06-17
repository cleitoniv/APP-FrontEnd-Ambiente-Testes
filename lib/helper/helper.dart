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

  static String equalValidator(String text, {String value}) {
    if (text != value) {
      return 'Campos não coincidem';
    }
    return null;
  }
}
