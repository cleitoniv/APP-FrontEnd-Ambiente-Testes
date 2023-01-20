import 'package:cached_network_image/cached_network_image.dart';
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

  static keyList(_data, index) {
    if (_data[index].containsKey('Olho direito')) {
      list() => _data[index]['Olho direito'].entries.map((e) => e.key).toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index].containsKey('Oho esquerdo')) {
      list() =>
          _data[index]['Olho esquerdo'].entries.map((e) => e.key).toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index].containsKey('Mesmo grau em ambos')) {
      list() => _data[index]['Mesmo grau em ambos']
          .entries
          .map((e) => e.key)
          .toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }

      // return finalResult();
      return keyProduct;
    } else if (_data[index].containsKey('Graus diferentes em cada olho')) {
      listRight() {
        if (_data[index]['Graus diferentes em cada olho']
            .containsKey('direito')) {
          return _data[index]['Graus diferentes em cada olho']['direito']
              .entries
              .map((entry) {
            return entry.key;
          }).toList();
        }
      }

      listLeft() {
        if (_data[index]['Graus diferentes em cada olho']
            .containsKey('esquerdo')) {
          return _data[index]['Graus diferentes em cada olho']['esquerdo']
              .entries
              .map((e) => e.key)
              .toList();
        }
      }

      var resultRight = listRight();
      var resultLeft = listLeft();
      List keyProductRight = [];
      for (var i = 0; i < resultRight.length; i++) {
        keyProductRight.add(resultRight[i]);
      }

      List keyProductLeft = [];
      for (var i = 0; i < resultLeft.length; i++) {
        keyProductLeft.add(resultLeft[i]);
      }
      return [resultRight, resultLeft];
    }
  }

  static dynamic productInfo(context, List info) {
    List childs = info
        .map((e) => Column(children: [
              Text(
                '${e}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
              ),
            ]))
        .toList();
    return childs;
    // Iterable dataInfo = info.map((inf) {
    //   return Column(
    //     children: [
    //       Container(
    //         child: Text(
    //           '${inf}',
    //           style: Theme.of(context).textTheme.subtitle1.copyWith(
    //                 color: Colors.black38,
    //                 fontSize: 14,
    //               ),
    //         ),
    //       ),
    //     ],
    //   );
    // });
    // return dataInfo;
  }

  static Widget CartList(List _data, Function hasPrice, Function removeItem,
      Function selectPrice) {
    return ListView.separated(
      primary: false,
      addSemanticIndexes: true,
      shrinkWrap: true,
      itemCount: _data.length,
      separatorBuilder: (context, index) => Divider(
        height: 25,
        thickness: 1,
        color: Colors.black12,
      ),
      itemBuilder: (context, index) {
        // print(_data[index]['Mesmo grau em ambos']);
        print(keyList(_data, index));
        var keyListResult = keyList(_data, index);
        print('linha 192 helper.dart');
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxHeight: 100, maxWidth: 100),
                        child: _data[index]["tests"] != "Sim" &&
                                _data[index]["type"] != "T"
                            ? CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                        'assets/images/no_image_product.jpeg'),
                                imageUrl: _data[index]['product'].imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill,
                              )
                            : _data[index]['product'].imageUrlTest == null
                                ? Image.asset(
                                    'assets/images/no_image_product.jpeg')
                                : CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/no_image_product.jpeg'),
                                    imageUrl:
                                        _data[index]['product'].imageUrlTest,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.fill,
                                  ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      hasPrice(_data[index])
                          ? Text(
                              selectPrice(_data[index]),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 12,
                                  ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${_data[index]['product'].title}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _data[index]['meta']['pendencie']
                              ? Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "PENDENTE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundColor: Helper.buyTypeBuild(
                                      context,
                                      _data[index]['operation'],
                                      _data[index]['tests'])['color'],
                                  radius: 10,
                                  child: Helper.buyTypeBuild(
                                      context,
                                      _data[index]['operation'],
                                      _data[index]['tests'])['icon']),
                              SizedBox(width: 5),
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  '${Helper.buyTypeBuild(context, _data[index]['operation'], _data[index]['tests'])['title']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      // productInfo(context, keyListResult),
                      SizedBox(width: 20)
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _data[index]['removeItem'] == 'Sim' ||
                              _data[index]['removeItem'] == null
                          ? IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                removeItem(_data[index]);
                              },
                            )
                          : Container()
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      },
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
