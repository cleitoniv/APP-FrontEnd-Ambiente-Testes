// import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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

  static String lengthValidatorContainsNumber(String text,
      {int length = 0,
      String message = 'Campo Obrigatório',
      String messageNumber =
          "Nome impresso no cartão deve conter somentes letras"}) {
    RegExp regExpNumber = RegExp(r'[0-9]');

    if (text.isEmpty || text.length < length) {
      return message;
    }
    if (regExpNumber.hasMatch(text) == true) {
      return messageNumber;
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
    return null;
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

  static whenDifferentOperation(
      operation, function, context, cartItems, requestsBloc, cartWidgetBloc) {
    var lookingCartOperations = cartItems.map((e) {
      return e['operation'];
    }).toList();
    
    if(!lookingCartOperations.isEmpty && (lookingCartOperations[0] == '01' || lookingCartOperations[0] == '04') && (operation == '01')) {
      function();
      return;
    }

    if(!lookingCartOperations.isEmpty && operation == '07' && lookingCartOperations[0] == '06') {
      function();
      return;
    }
    if (!lookingCartOperations.isEmpty &&
        operation != lookingCartOperations[0] ) {
      return Dialogs.confirm(
        context,
        title: 'Deseja limpar o carrinho?',
        subtitle:
            'Identificamos que está tentando inserir no carrinho produtos de operações diferentes!',
        confirmText: 'Sim',
        cancelText: 'Não',
        onCancel: () {
          Modular.to.pop();
        },
        onConfirm: () {
          requestsBloc.resetCart();
          cartWidgetBloc.cartTotalItemsSink.add(0);
          Modular.to.pop();
          function();
        },
      );
    } else {
      function();
    }
  }

  static keyList(_data, index) {
    if (_data[index].containsKey('Olho direito')) {
      _data[index]['Olho direito']['quantidade'] = _data[index]['quantity'];
      var params = _data[index]['Olho direito'];
      if (params['cylinder'] == '') {
        _data[index]['Olho direito'].remove('cylinder');
      }
      if (params['axis'] == '') {
        _data[index]['Olho direito'].remove('axis');
      }
      if (params['lenses'] == '') {
        _data[index]['Olho direito'].remove('lenses');
      }
      if (params['cor'] == '') {
        _data[index]['Olho direito'].remove('cor');
      }
      if (params['adicao'] == '') {
        _data[index]['Olho direito'].remove('adicao');
      }

      list() => _data[index]['Olho direito'].entries.map((e) => e.key).toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index]['operation'] == '06') {
      return ['quantidade'];
    } else if (_data[index].containsKey('Olho esquerdo')) {
      _data[index]['Olho esquerdo']['quantidade'] = _data[index]['quantity'];
      var params = _data[index]['Olho esquerdo'];
      if (params['cylinder'] == '') {
        _data[index]['Olho esquerdo'].remove('cylinder');
      }
      if (params['axis'] == '') {
        _data[index]['Olho esquerdo'].remove('axis');
      }
      if (params['lenses'] == '') {
        _data[index]['Olho esquerdo'].remove('lenses');
      }
      if (params['cor'] == '') {
        _data[index]['Olho esquerdo'].remove('cor');
      }
      if (params['adicao'] == '') {
        _data[index]['Olho esquerdo'].remove('adicao');
      }

      list() =>
          _data[index]['Olho esquerdo'].entries.map((e) => e.key).toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }

      return keyProduct;
    } else if (_data[index].containsKey('Mesmo grau em ambos')) {
      _data[index]['Mesmo grau em ambos']['quantidade'] =
          _data[index]['quantity'];
      var params = _data[index]['Mesmo grau em ambos'];
      if (params['cylinder'] == '') {
        _data[index]['Mesmo grau em ambos'].remove('cylinder');
      }
      if (params['axis'] == '') {
        _data[index]['Mesmo grau em ambos'].remove('axis');
      }
      if (params['lenses'] == '') {
        _data[index]['Mesmo grau em ambos'].remove('lenses');
      }
      if (params['cor'] == '') {
        _data[index]['Mesmo grau em ambos'].remove('cor');
      }
      if (params['adicao'] == '') {
        _data[index]['Mesmo grau em ambos'].remove('adicao');
      }
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
          _data[index]['Graus diferentes em cada olho']['direito']
              ['quantidade'] = _data[index]['quantity_for_eye']['direito'];

          var params = _data[index]['Graus diferentes em cada olho']['direito'];
          if (params['cylinder'] == '') {
            _data[index]['Graus diferentes em cada olho']['direito']
                .remove('cylinder');
          }
          if (params['axis'] == '') {
            _data[index]['Graus diferentes em cada olho']['direito']
                .remove('axis');
          }
          if (params['lenses'] == '') {
            _data[index]['Graus diferentes em cada olho']['direito']
                .remove('lenses');
          }
          if (params['cor'] == '') {
            _data[index]['Graus diferentes em cada olho']['direito']
                .remove('cor');
          }
          if (params['adicao'] == '') {
            _data[index]['Graus diferentes em cada olho']['direito']
                .remove('adicao');
          }
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
          _data[index]['Graus diferentes em cada olho']['esquerdo']
              ['quantidade'] = _data[index]['quantity_for_eye']['esquerdo'];
          var params =
              _data[index]['Graus diferentes em cada olho']['esquerdo'];
          if (params['cylinder'] == '') {
            _data[index]['Graus diferentes em cada olho']['esquerdo']
                .remove('cylinder');
          }
          if (params['axis'] == '') {
            _data[index]['Graus diferentes em cada olho']['esquerdo']
                .remove('axis');
          }
          if (params['lenses'] == '') {
            _data[index]['Graus diferentes em cada olho']['esquerdo']
                .remove('lenses');
          }
          if (params['cor'] == '') {
            _data[index]['Graus diferentes em cada olho']['esquerdo']
                .remove('cor');
          }
          if (params['adicao'] == '') {
            _data[index]['Graus diferentes em cada olho']['esquerdo']
                .remove('adicao');
          }
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
      resultRight.insert(0, "Olho");
      resultLeft.insert(0, "Olho");
      return {'direito': resultRight, 'esquerdo': resultLeft};
    }
  }

  static paramsList(_data, index) {
    if (_data[index].containsKey('Olho direito')) {
      list() =>
          _data[index]['Olho direito'].entries.map((e) => e.value).toList();
      var result = list();
      
      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index]['operation'] == '06') {
      var newlist = _data[index];
      list2() => [newlist].map((e) => e['quantity']).toList();
      var result = list2();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index].containsKey('Olho esquerdo')) {
      list() =>
          _data[index]['Olho esquerdo'].entries.map((e) => e.value).toList();
      var result = list();

      List keyProduct = [];
      for (var i = 0; i < result.length; i++) {
        keyProduct.add(result[i]);
      }
      return keyProduct;
    } else if (_data[index].containsKey('Mesmo grau em ambos')) {
      list() => _data[index]['Mesmo grau em ambos']
          .entries
          .map((e) => e.value)
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
            return entry.value;
          }).toList();
        }
      }

      listLeft() {
        if (_data[index]['Graus diferentes em cada olho']
            .containsKey('esquerdo')) {
          return _data[index]['Graus diferentes em cada olho']['esquerdo']
              .entries
              .map((e) => e.value)
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
      resultRight.insert(0, "Direito");
      resultLeft.insert(0, "Esquerdo");

      return {'direito': resultRight, 'esquerdo': resultLeft};
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
    var translatedKeys = {
      'Olho': 'Olho',
      'cylinder': 'Cilindro',
      'axis': 'Eixo',
      'lenses': 'Lente',
      'degree': 'Grau',
      'codigo': 'Codigo',
      'adicao': 'Adição',
      'quantidade': 'Quantidade',
      'valor': 'Valor',
      'cor': 'Cor'
    };
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
        var keyListResult = keyList(_data, index);
        var paramsListResult = paramsList(_data, index);
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 115,
                ),
                Center(
                    child: Column(
                  // height: 50,
                  // mainAxisAlignment: MainAxisAlignment.start
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(
                    '${_data[index]['product'].title}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 12,
                        ),
                    maxLines: 1,),
                    hasPrice(_data[index])
                            ? Text(
                                'Valor Unitario: ${selectPrice(_data[index])}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                              )
                            : Container(),
                    ],
                ),),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            constraints:
                                BoxConstraints(maxHeight: 100, maxWidth: 100),
                            child: _data[index]["tests"] != "Sim" &&
                                    _data[index]["type"] != "T"
                                ? CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                            'assets/images/no_image_product.jpeg'),
                                    imageUrl: _data[index]['product'].imageUrl,
                                    width: 100,
                                    height: 80,
                                  )
                                : _data[index]['product'].imageUrlTest == null
                                    ? Image.asset(
                                        'assets/images/no_image_product.jpeg')
                                    : CachedNetworkImage(
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/no_image_product.jpeg'),
                                        imageUrl: _data[index]['product']
                                            .imageUrlTest,
                                        width: 80,
                                        height: 80,
                                      ),
                          )
                        ],
                      ),
                      // Container(
                      //   alignment: Alignment.topCenter,
                      //   child: hasPrice(_data[index])
                      //       ? Text(
                      //           selectPrice(_data[index]),
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .headline5
                      //               .copyWith(
                      //                 fontSize: 12,
                      //               ),
                      //         )
                      //       : Container(),
                      // )
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                // elevation: 2,
                                child: Container(
                                  width: 62,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  // padding: EdgeInsets.only(
                                  //     top: 8, bottom: 8, left: 10, right: 10),
                                  child: _data[index]['current'] !=
                                          'Graus diferentes em cada olho'
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              keyListResult.map<Widget>((e) {
                                            if (e == 'codigo') {
                                              return Container();
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${translatedKeys[e]}",
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: keyListResult['direito']
                                                  .map<Widget>((e) {
                                                if (e == 'codigo') {
                                                 return Container();
                                                }
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${translatedKeys[e]}",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }).toList() +
                                              [
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ] +
                                              keyListResult['esquerdo']
                                                  .map<Widget>((e) {
                                                if (e == 'codigo') {
                                                 return Container();
                                                }
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "${translatedKeys[e]}",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              }).toList(),
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Material(
                                  // elevation: 2,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    // padding: EdgeInsets.only(
                                    //     top: 8, bottom: 8, left: 1, right: 8),
                                    child: _data[index]['current'] !=
                                            'Graus diferentes em cada olho'
                                        ? Column(
                                            children: paramsListResult
                                                .map<Widget>((e) {
                                                  if (e.toString().length == 10 && e.toString().contains('C') || e.toString().length == 10 && e.toString().contains('T')) {
                                                    return Container();
                                                  }
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                      child: Column(
                                                    children: [
                                                      Text("${e}",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                          maxLines: 1,
                                                          softWrap: false,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ],
                                                  ))
                                                ],
                                              );
                                            }).toList(),
                                          )
                                        : Column(
                                            children: paramsListResult[
                                                        'direito']
                                                    .map<Widget>((e) {
                                                  if (e.toString().length == 10 && e.toString().contains('C') || e.toString().length == 10 && e.toString().contains('T')) {
                                                    return Container();
                                                  }
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                          child: Column(
                                                        children: [
                                                          Text("${e}",
                                                              style: TextStyle(
                                                                  fontSize: 11),
                                                              maxLines: 1,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ))
                                                    ],
                                                  );
                                                }).toList() +
                                                [
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ] +
                                                paramsListResult['esquerdo']
                                                    .map<Widget>((e) {
                                                  if (e.toString().length == 10 && e.toString().contains('C') || e.toString().length == 10 && e.toString().contains('T')) {
                                                    return Container();
                                                  }
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Flexible(
                                                          child: Column(
                                                        children: [
                                                          Text("${e}",
                                                              style: TextStyle(
                                                                  fontSize: 11),
                                                              maxLines: 1,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ],
                                                      ))
                                                    ],
                                                  );
                                                }).toList(),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _data[index]['meta'] != null
                                      ? _data[index]['meta']['pendencie']
                                          ? Container(
                                              width: 80,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                "PENDENTE",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )
                                          : Container()
                                      : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  // Row(
                                  //   children: [
                                  //     CircleAvatar(
                                  //         backgroundColor: Helper.buyTypeBuild(
                                  //             context,
                                  //             _data[index]['operation'],
                                  //             _data[index]['tests'])['color'],
                                  //         radius: 10,
                                  //         child: Helper.buyTypeBuild(
                                  //             context,
                                  //             _data[index]['operation'],
                                  //             _data[index]['tests'])['icon']),
                                  //     SizedBox(width: 10),
                                      // Text(
                                      //   '${Helper.buyTypeBuild(context, _data[index]['operation'], _data[index]['tests'])['title']}',
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .subtitle1
                                      //       .copyWith(
                                      //         fontSize: 12,
                                      //       ),
                                      // ),
                                  //   ],
                                  // )
                                ],
                              ))
                              // SizedBox(width: 20)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          _data[index]['removeItem'] == 'Sim' ||
                                  _data[index]['removeItem'] == null
                              ? IconButton(
                                iconSize: 5,
                                  icon: Image.asset(
                              'assets/images/Lata_de_lixo.png',
                              fit: BoxFit.scaleDown,
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
            ),
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
