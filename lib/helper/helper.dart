import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class Helper {
  static String lengthValidator(
    String text, {
    int length = 0,
    String message = 'Campo Obrigatório',
  }) {
    if (text.isEmpty || text.length < length) {
      return message;
    }

    return null;
  }

  static String passwordValidator(String text, {int length = 0}) {
    String message =
        "Sua senha deve ser composta por no mínimo $length dígitos, incluindo letras e números";

    RegExp regExpNumber = RegExp(r'[0-9]');
    RegExp regExpString = RegExp(r'[a-zA-Z]');

    if (text.length < length ||
        regExpNumber.hasMatch(text) == false ||
        regExpString.hasMatch(text) == false) {
      return message;
    }
  }

  static String lengthValidatorHelpDesk(
    String text, {
    int length = 0,
    int maxLength = 120,
    String message = 'Campo Obrigatório',
  }) {
    if (text.isEmpty || text.length < length) {
      return message;
    } else if (text.length > maxLength) {
      return 'A quantidade de caracteres digitada é maior que a permitida.';
    }

    return null;
  }

  static String lengthValidatorDdd(
    String text, {
    int length = 0,
    String message = 'Campo Obrigatório',
  }) {
    if (text.isEmpty || text.length < length) {
      return message;
    }
    if (text[0] == '0') {
      return 'DDD não pode iniciar com zero';
    }

    return null;
  }

  static String emailValidator(String text) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(text);
    if (text.isEmpty ||
        text.indexOf('@') == -1 ||
        text.indexOf('.') == -1 ||
        !emailValid) {
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

  static String cpfValidator(
    String text, {
    String message = 'CPF Inválido!',
  }) {
    if (!CPF.isValid(text)) {
      return message;
    }
    return null;
  }

  static intToMoney(int value) {
    return '${NumberFormat('#,##0.00', 'pt_BR').format((value ?? 0) / 100)}';
  }

  static moneyToInt(double value) {
    return int.parse(
      value.toString().replaceAll(',', '.').replaceAll('.', ''),
    );
  }

  static handleFirebaseError(
    String error,
  ) {
    if (error.contains('ERROR')) {
      String _message = '';
      switch (error) {
        case 'ERROR_USER_NOT_FOUND':
          _message = 'Usuário não encontrado';
          break;
        case 'ERROR_INVALID_EMAIL':
          _message = 'Email inválido';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _message = 'Este email já está em uso';
          break;
        case 'ERROR_WRONG_PASSWORD':
          _message = 'Senha incorreta';
          break;
        case 'ERROR_REQUIRES_RECENT_LOGIN':
          _message = 'Login recente';
          break;
        default:
          _message = '$error';
      }

      return _message;
    }
  }

  static dateToWeek(String date) {
    DateTime _dateTime = DateTime.parse(date);

    switch (_dateTime.weekday) {
      case 1:
        return 'Segunda-Feira';
      case 2:
        return 'Terça-Feira';
      case 3:
        return 'Quarta-Feira';
      case 4:
        return 'Quinta-Feira';
      case 5:
        return 'Sexta-Feira';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
    }
  }

  static String dateToMonth(String date) {
    DateTime _dateTime = DateTime.parse(date);

    int _day = _dateTime.day;
    String _month;
    switch (_dateTime.month) {
      case 1:
        _month = 'Janeiro';
        break;
      case 2:
        _month = 'Fevereiro';
        break;
      case 3:
        _month = 'Março';
        break;
      case 4:
        _month = 'Abril';
        break;
      case 5:
        _month = 'Maio';
        break;
      case 6:
        _month = 'Junho';
        break;
      case 7:
        _month = 'Julho';
        break;
      case 8:
        _month = 'Agosto';
        break;
      case 9:
        _month = 'Setembro';
        break;
      case 10:
        _month = 'Outubro';
        break;
      case 11:
        _month = 'Novembro';
        break;
      case 12:
        _month = 'Dezembro';
        break;
    }

    return '$_day de\n$_month';
  }

  static String sqlToDate(String date) {
    try {
      DateFormat _format = DateFormat('dd/MM/yyyy');
      DateTime _dateTime = DateTime.parse(date);
      String _formatDate = _format.format(_dateTime);

      return _formatDate;
    } catch (error) {
      return "-";
    }
  }

  static Map<String, dynamic> buyTypeBuildRequestInfo(
      BuildContext context, String operation, String tests) {
    switch (operation) {
      case '13':
        return {
          'title': 'Financeiro',
          'color': Theme.of(context).primaryColor,
          'background': Colors.green[300],
          'icon': Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 20,
          )
        };
      case '04':
        switch (tests) {
          case 'S':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };
        }
        break;
      case '01':
        switch (tests) {
          case 'S':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };

          case 'N':
            return {
              'title': 'Avulso',
              'color': Color(0xff707070),
              'background': Color(0xff707070),
              'icon': Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 20,
              )
            };
        }
        break;

      case '07':
        switch (tests) {
          case 'S':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };

          case 'N':
            return {
              'title': 'Produto',
              'color': Theme.of(context).splashColor,
              'background': Color(0xffEFC75E),
              'icon': Image.asset(
                'assets/icons/open_box.png',
                width: 15,
                height: 15,
                color: Colors.white,
              )
            };
        }
        break;
      case '03':
        return {
          'title': 'Teste',
          'color': Colors.white,
          'background': Colors.white10,
          'icon': Icon(
            Icons.remove_red_eye,
            color: Colors.black54,
            size: 23,
          )
        };
      case '06':
        return {
          'title': 'Produto',
          'color': Theme.of(context).splashColor,
          'background': Color(0xffEFC75E),
          'icon': Image.asset(
            'assets/icons/open_box.png',
            width: 15,
            height: 15,
            color: Colors.white,
          )
        };
    }

    return {};
  }

  static Map<String, dynamic> buyTypeBuild(
      BuildContext context, String operation, String tests) {
    print("331");
    print(operation);
    switch (operation) {
      case '13':
        return {
          'title': 'Financeiro',
          'color': Theme.of(context).primaryColor,
          'background': Colors.green[300],
          'icon': Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 20,
          )
        };
      case '01':
        switch (tests) {
          case 'Sim':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };
            break;

          case 'Não':
            return {
              'title': 'Avulso',
              'color': Color(0xff707070),
              'background': Color(0xff707070),
              'icon': Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 20,
              )
            };
            break;
        }
        break;
      case '04':
        switch (tests) {
          case 'Sim':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };
            break;
        }
        break;
      case '07':
        switch (tests) {
          case 'Sim':
            return {
              'title': 'Teste',
              'color': Colors.white,
              'background': Color(0xffF1F1F1),
              'icon': Icon(
                Icons.remove_red_eye,
                color: Colors.black54,
                size: 23,
              )
            };
            break;
          case 'Não':
            return {
              'title': 'Produto',
              'color': Theme.of(context).splashColor,
              'background': Color(0xffEFC75E),
              'icon': Image.asset(
                'assets/icons/open_box.png',
                width: 15,
                height: 15,
                color: Colors.white,
              )
            };
            break;
        }
        break;

      case '03':
        return {
          'title': 'Teste',
          'color': Colors.white,
          'background': Color(0xffF1F1F1),
          'icon': Icon(
            Icons.remove_red_eye,
            color: Colors.black54,
            size: 23,
          )
        };
      case '06':
        return {
          'title': 'Produto',
          'color': Theme.of(context).splashColor,
          'background': Color(0xffEFC75E),
          'icon': Image.asset(
            'assets/icons/open_box.png',
            width: 15,
            height: 15,
            color: Colors.white,
          )
        };
    }

    return {};
  }
}
