import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static Map<String, dynamic> buyTypeBuild(BuildContext context, String type) {
    switch (type) {
      case 'A':
        return {
          'title': 'Avulso',
          'color': Color(0xff707070),
          'icon': Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 20,
          )
        };
      case 'A':
        return {
          'title': 'Financeiro',
          'color': Theme.of(context).primaryColor,
          'icon': Icon(
            Icons.attach_money,
            color: Colors.white,
            size: 20,
          )
        };
      case 'C':
        return {
          'title': 'Produto',
          'color': Theme.of(context).splashColor,
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
