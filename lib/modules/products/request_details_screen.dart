import 'dart:developer';
// import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/helper/modals.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
// import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:random_string/random_string.dart';

class RequestDetailsScreen extends StatefulWidget {
  final int id;
  final String type;
  final ProductModel product;

  RequestDetailsScreen({
    this.id,
    this.type = 'Avulso',
    this.product,
  });

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  List<Map> _fieldData;
  bool isInvalid = false;
  TextEditingController _nameController;
  TextEditingController _lensDireitoController;
  TextEditingController _lensEsquerdoController;
  TextEditingController _lensController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;
  Product currentProduct;
  FocusNode caixasFocus = new FocusNode();
  FocusNode caixasOlhoEsquerdoFocus = new FocusNode();
  FocusNode caixasOlhoDireitoFocus = new FocusNode();
  bool _isLoadingSecondButton;
  bool _isLoadingPrimaryButton;
  bool _isProcessing;
  String _hasTests = 'Não';

  int _calculateCreditProduct() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;

    int _total = _cart.fold(0, (previousValue, element) {
      if (element["operation"] == "07" &&
          element['product'].group == currentProduct.product.group &&
          element['tests'] == 'Não') {
        return previousValue + element['quantity'];
      }
      return previousValue;
    });
    return _total;
  }

  int _calculateCreditFinancial() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;
    int _total = _cart.fold(0, (previousValue, element) {
      if (element["operation"] == "13" && element['tests'] == 'Não') {
        return previousValue +
            (element['quantity'] * element["product"].valueFinan);
      }
      return previousValue;
    });
    return _total;
  }

  int _calculateCreditTest() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;
    int _total = _cart.fold(0, (previousValue, element) {
      if (((element["operation"] == "03" &&
              element['product'].group == currentProduct.product.group)) ||
          (element["operation"] == "07" &&
              element['product'].group == currentProduct.product.group &&
              element['tests'] == 'Sim')) {
        return previousValue + element['quantity'];
      }
      return previousValue;
    });
    return _total;
  }

  int _calculateProductCreditTest() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;
    int _total = _cart.fold(0, (previousValue, element) {
      if ((element["operation"] == "03" &&
              element['product'].group == currentProduct.product.group) ||
          (element["operation"] == "07" &&
              element['product'].group == currentProduct.product.group &&
              element['tests'] == 'Sim')) {
        return previousValue + element['quantity'];
      }
      return previousValue;
    });
    return _total;
  }

  _verifyFontSize() {
    if (MediaQuery.of(context).textScaleFactor < 1.5) {
      return 16.0;
    } else {
      return 12.0;
    }
  }

  _updateQtdCart(Map _data) {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;

    List _cartCopy = new List.from(_cart);

    _cartCopy.add(_data);

    Map totals = _cartCopy.fold({}, (acc, element) {
      String current = element['current'];
      if (current == 'Graus diferentes em cada olho') {
        String codigoDireito = element[current]['direito']['codigo'];
        String codigoEsquerdo = element[current]['esquerdo']['codigo'];
        acc[codigoDireito] =
            (acc[codigoDireito] ?? 0) + element['quantity_for_eye']['direito'];
        acc[codigoEsquerdo] = (acc[codigoEsquerdo] ?? 0) +
            element['quantity_for_eye']['esquerdo'];
      } else {
        String codigo = element[current]['codigo'];
        if (current == 'Olho direito') {
          acc[codigo] =
              (acc[codigo] ?? 0) + element['quantity_for_eye']['direito'];
        } else {
          acc[codigo] =
              (acc[codigo] ?? 0) + element['quantity_for_eye']['esquerdo'];
        }
      }
      return acc;
    });
    Map result = {};
    String current = _data['current'];
    totals.entries.forEach((codigo) {
      if (current == 'Graus diferentes em cada olho') {
        if (codigo.key == _data[current]['esquerdo']['codigo']) {
          result[codigo.key] = {
            'qtd': codigo.value,
            'params': _data[current]['esquerdo']
          };
        } else if (codigo.key == _data[current]['direito']['codigo']) {
          result[codigo.key] = {
            'qtd': codigo.value,
            'params': _data[current]['direito']
          };
        }
      } else if (codigo.key == _data[current]['codigo']) {
        result[codigo.key] = {'qtd': codigo.value, 'params': _data[current]};
      }
    });
    return result;
  }

  _verifyFontSize2() {
    if (MediaQuery.of(context).textScaleFactor < 1.5) {
      return 16.0;
    } else {
      return 8.0;
    }
  }

  _showDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: Theme.of(context).textTheme.headline5),
          content: Text(content),
          actions: [
            ElevatedButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Modular.to.pop();
                })
          ],
        );
      },
    );
  }

  _onAddLens() {
    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();

    var _pacientInfo = _productWidgetBloc.pacientInfo;
    int factor;
    if (_pacientInfo['current'] == 'Mesmo grau em ambos') {
      factor = 2;
    } else {
      factor = 1;
    }

    if (_lensController.text == '') _lensController.text = '0';

    if (widget.type == "C") {
      int olho = int.parse(_lensController.text) * factor;
      if (currentProduct.product.boxes > olho + cartTotal) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Você possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "T") {
      int olho = int.parse(_lensController.text) * factor;
      if (currentProduct.product.tests > olho + _cartTotalTest) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Você possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "CF") {
      int olho = int.parse(_lensController.text) * factor;
      if (_authBloc.getAuthCurrentUser.data.money >
          olho * currentProduct.product.valueFinan + _cartTotalFinancial) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Você possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else {
      _lensController.text = '${int.parse(_lensController.text) + 1}';
    }
  }

  _onRemoveLens() {
    if (int.parse(_lensController.text) > 1) {
      _lensController.text = '${int.parse(_lensController.text) - 1}';
    }
  }

  _onAddLensDireito() {
    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();
    int olhoDireito = int.parse(
        _lensDireitoController.text == '' ? '0' : _lensDireitoController.text);
    int olhoEsquerdo = int.parse(_lensEsquerdoController.text == ''
        ? '0'
        : _lensEsquerdoController.text);

    if (widget.type == "C") {
      if (currentProduct.product.boxes >
          olhoDireito + olhoEsquerdo + cartTotal) {
        _lensDireitoController.text = '${olhoDireito + 1}';
      } else {
        _showDialog("Limite atingido.",
            "O limite de caixa estorou. Você possui menos que a quantidade selecionada, verifique se contém caixas a mais no carrinho.");
        return _lensDireitoController.text = "1";
      }
    } else if (widget.type == "T") {
      if (currentProduct.product.tests >
          olhoDireito + olhoEsquerdo + _cartTotalTest) {
        _lensDireitoController.text = '${olhoDireito + 1}';
      } else {
        _showDialog("Limite atingido.",
            "O limite de caixa estorou. Você possui menos que a quantidade selecionada, verifique se contém caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "CF") {
      if (_authBloc.getAuthCurrentUser.data.money >
          (olhoEsquerdo + olhoDireito) * currentProduct.product.valueFinan +
              _cartTotalFinancial) {
        _lensDireitoController.text = '${olhoDireito + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensDireitoController.text = "1";
      }
    } else {
      _lensDireitoController.text =
          '${int.parse(_lensDireitoController.text) + 1}';
    }
  }

  _onAddLensEsquerdo() {
    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();
    int olhoDireito = int.parse(
        _lensDireitoController.text == '' ? '0' : _lensDireitoController.text);
    int olhoEsquerdo = int.parse(_lensEsquerdoController.text == ''
        ? '0'
        : _lensEsquerdoController.text);

    if (widget.type == "C") {
      if (currentProduct.product.boxes >
          olhoDireito + olhoEsquerdo + cartTotal) {
        _lensEsquerdoController.text =
            '${int.parse(_lensEsquerdoController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "T") {
      if (currentProduct.product.tests >=
          olhoDireito + olhoEsquerdo + _cartTotalTest) {
        _lensEsquerdoController.text = '${olhoEsquerdo + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensEsquerdoController.text = "1";
      }
    } else if (widget.type == "CF") {
      if (_authBloc.getAuthCurrentUser.data.money >
          (olhoDireito + olhoEsquerdo) * currentProduct.product.valueFinan +
              _cartTotalFinancial) {
        _lensEsquerdoController.text = '${olhoEsquerdo + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensEsquerdoController.text = "1";
      }
    } else {
      _lensEsquerdoController.text = '${olhoEsquerdo + 1}';
    }
  }

  _onRemoveLensDireito() {
    if (int.parse(_lensDireitoController.text) > 1) {
      _lensDireitoController.text =
          '${int.parse(_lensDireitoController.text) - 1}';
    }
  }

  _onRemoveLensEsquerdo() {
    if (int.parse(_lensEsquerdoController.text) > 1) {
      _lensEsquerdoController.text =
          '${int.parse(_lensEsquerdoController.text) - 1}';
    }
  }

  _verifyBuy() {
    if (widget.type == "A") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.value)}';
    } else if (widget.type == "C") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.valueProduto)}';
    } else if (widget.type == "CF") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.valueFinan)}';
    } else if (widget.type == "T") {
      return '';
    }
  }

  _getBuyValue(String type) {
    if (type == "A") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.value)}';
    } else if (type == "C") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.valueProduto)}';
    } else if (type == "CF") {
      return 'R\$ ${Helper.intToMoney(currentProduct.product.valueFinan)}';
    } else if (type == "T") {
      return '';
    }
  }

  _verifyType() {
    if (widget.type == "A") {
      return "Avulso";
    } else if (widget.type == "C") {
      return "Produto";
    } else if (widget.type == "CF") {
      return "Financeiro";
    } else if (widget.type == "T") {
      return "Teste";
    }
  }

  _getType(String type) {
    if (type == "A") {
      return "Avulso";
    } else if (type == "C") {
      return "Produto";
    } else if (type == "CF") {
      return "Financeiro";
    } else if (type == "T") {
      return "Teste";
    }
  }

  String _parseType(String type) {
    return type == "CF" ? "A" : type;
  }

  String _parseOperation(String type) {
    if (type == "C") {
      return "07";
    } else if (type == "CF") {
      return "13";
    }
    if (type == "T") {
      return "03";
    } else {
      return "01";
    }
  }

  Widget _accessory(Widget widget) {
    return currentProduct.product.hasAcessorio ? widget : Container();
  }

  Widget _checkForAcessorio(Widget widget) {
    return !currentProduct.product.hasAcessorio ? widget : Container();
  }

  Future<Map<String, dynamic>> _checkParametersGrausDiferentes(
      Map<String, dynamic> data, Map<String, dynamic> allowedParams) async {
    Map<String, dynamic> errorParams = {};

    data.keys.forEach((olho) {
      if (olho != "group") {
        if (data[olho].keys.any((element) => data[olho][element] == "")) {
          data[olho].keys.forEach((element) {
            String key;
            if (data[olho][element] == "") {
              if (allowedParams[element] ?? false) {
                switch (element) {
                  case "axis":
                    key = "Eixo $olho";
                    break;
                  case "cylinder":
                    key = "Cilindro $olho";
                    break;
                  case "degree":
                    key = "Esferico $olho";
                    break;
                  case "cor":
                    key = "Cor $olho";
                    break;
                  case "adicao":
                    key = "Adicao $olho";
                    break;
                }
                errorParams[key] = ["Nao pode estar vazio."];
              }
            }
          });
        }
      }
    });
    Map<String, dynamic> errors =
        await _productBloc.checkProductGrausDiferentes(data, allowedParams);
    return {...errors, ...errorParams};
  }

  Future<Map<String, dynamic>> _checkParameters(
      Map data, ProductModel product, Map<String, dynamic> first) async {
    Map<String, dynamic> params = {};
    Map<String, dynamic> errors = {};

    data.remove("lenses");

    Map<String, dynamic> allowedParams = {
      "axis": product.hasEixo ?? false,
      "cylinder": product.hasCilindrico ?? false,
      "degree": product.hasEsferico ?? false,
      "cor": product.hasCor ?? false,
      "adicao": product.hasAdicao ?? false,
      "codigo": true
    };

    if (first['current'] == "Graus diferentes em cada olho") {
      data["group"] = product.group;

      return _checkParametersGrausDiferentes(
          new Map<String, dynamic>.from(data), allowedParams);
    }

    data.keys.forEach((element) {
      if (allowedParams[element]) {
        params[element] = "${data[element]}";
      }
    });

    params["group"] = product.group;
    final productAvailable = await _productBloc.checkProduct(params);

    if (!productAvailable) {
      errors["Produto"] = ["Produto indisponivel no momento."];
    }
    if (params.keys.any((element) => params[element] == "")) {
      params.keys.forEach((element) {
        if (params[element] == "") {
          String key;
          switch (element) {
            case "axis":
              key = "Eixo";
              break;
            case "cylinder":
              key = "Cilindro";
              break;
            case "degree":
              key = "Grau";
              break;
            case "cor":
              key = "Cor";
              break;
            case "adicao":
              key = "Adicao";
              break;
          }
          errors[key] = ["Nao pode estar vazio."];
        }
      });
      return errors;
    }

    return errors;
  }

  _lockCart(locked) {
    setState(() {
      _isProcessing = locked;
    });
  }

  int _productQuantity(bool isSameDegree) {
    int _quantity = int.parse(_lensDireitoController.text) +
        int.parse(_lensEsquerdoController.text) +
        int.parse(_lensController.text);

    int _qtd = isSameDegree ? int.parse(_lensController.text) * 2 : _quantity;

    return _qtd;
  }

  var dataProductCode = [
    {
      "olho": "Olho direito",
      "quantidade": 3,
      "esferico": -8,
      "grupo": "010C",
      "cilindrico": -1.75,
      "eixo": 80,
      "adicao": 0
    },
    {
      "olho": "Olho esquerdo",
      "quantidade": 2,
      "esferico": -8,
      "grupo": "010C",
      "cilindrico": -1.25,
      "eixo": 80,
      "adicao": 0
    }
  ];

  List<Map> productCodeList(_first) {
    String current = _first['current'];
    if (current == 'Graus diferentes em cada olho') {
      return _first[current].entries.map<Map<String, dynamic>>((entry) {
        print(entry);
        return {
          "olho": entry.key,
          "esferico": entry.value['degree'],
          "grupo": currentProduct.product.group,
          "cilindrico": entry.value['cylinder'],
          "eixo": entry.value['axis'],
          "adicao": entry.value['adicao'],
          "cor": entry.value['cor']
        };
      }).toList();
    } else {
      print(_first[current]);
      return List<Map<String, dynamic>>.of([
        Map<String, dynamic>.of({
          "olho": current,
          "esferico": _first[current]['degree'] ?? "",
          "grupo": currentProduct.product.group,
          "cilindrico": _first[current]['cylinder'] ?? "",
          "eixo": _first[current]['axis'] ?? "",
          "adicao": _first[current]['adicao'] ?? "",
          "cor": _first[current]['cor'].toLowerCase() ?? ""
        })
      ]);
    }
  }

  List<Map> productCodeTestList(_first) {
    String current = _first['current'];
    if (current == 'Graus diferentes em cada olho') {
      return _first[current].entries.map<Map<String, dynamic>>((entry) {
        return {
          "olho": entry.key,
          "esferico": entry.value['degree'],
          "grupo": currentProduct.product.groupTest,
          "cilindrico": entry.value['cylinder'],
          "eixo": entry.value['axis'],
          "adicao": entry.value['adicao'],
          "cor": entry.value['cor']
        };
      }).toList();
    } else {
      return List<Map<String, dynamic>>.of([
        Map<String, dynamic>.of({
          "olho": current,
          "esferico": _first[current]['degree'] ?? "",
          "grupo": currentProduct.product.groupTest,
          "cilindrico": _first[current]['cylinder'] ?? "",
          "eixo": _first[current]['axis'] ?? "",
          "adicao": _first[current]['adicao'] ?? "",
          "cor": _first[current]['cor'].toLowerCase() ?? ""
        })
      ]);
    }
  }

  Map _putProductCode(_first, result) {
    String current = _first['current'];
    print('------- 646');
    print(result);
    print(_first);
    if (current == 'Graus diferentes em cada olho') {
      result['data'].forEach((item) {
        _first[current][item['olho']]['codigo'] = item['codigo']['codigo'];
      });
      return _first;
    } else {
      if (result['data'][0]['codigo'] != null) {
        _first[current]['codigo'] =
            result['data'] != null ? result['data'][0]['codigo']['codigo'] : [];
        return _first;
      } else {
        return _first;
      }
    }
  }



  _onAddToCart(Map data, String typeButton, Map meta) async {
    _lockCart(true);

    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;
    var result = await _productBloc.productCode(productCodeList(_first));
    _first = _putProductCode(_first, result);
    // return;
    int itemQuantity =
        _productQuantity(_first['current'] == "Mesmo grau em ambos");

    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();
    int _cartProductTest = _calculateProductCreditTest();

    int _quantity = int.parse(_lensDireitoController.text) +
        int.parse(_lensEsquerdoController.text) +
        int.parse(_lensController.text);

    int _qtd = _first['current'] == "Mesmo grau em ambos"
        ? int.parse(_lensController.text) * 2
        : _quantity;
    if (_authBloc.getAuthCurrentUser.data.money <
            ((_qtd * currentProduct.product.valueFinan) +
                _cartTotalFinancial) &&
        widget.type == "CF") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Seu saldo é inferior a quantidade desejada."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      _lockCart(false);
      return;
    }
    if (currentProduct.product.tests < _qtd + _cartTotalTest &&
        widget.type == "T") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      _lockCart(false);
      return;
    }
    if (widget.type == "C") {
      if (currentProduct.product.boxes < _qtd + cartTotal) {
        SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
          "Limite Atingido": ["Limite de caixas atingido."]
        });
        _scaffoldKey.currentState.showSnackBar(
          _snack,
        );
        _lockCart(false);
        return;
      } else if (_hasTests == 'Sim' &&
          (_qtd + _cartProductTest > currentProduct.product.tests)) {
        _showDialog("Operação invalida",
            "Voce possui menos que a quantidade selecionada de testes para este pedido, por isso nao podemos realizar a operação.");
        _lockCart(false);
        return;
      }
    }
    var invalidBoxes = SnackBar(
        content: Text("Quantidade de caixas tem que ser maior que 0."));

    Map<dynamic, dynamic> _checkTypeLens =
        await _productWidgetBloc.pacientInfoOut.first;

    if (_checkTypeLens['current'] == "Graus diferentes em cada olho") {
      if (_lensDireitoController.text == "" ||
          int.parse(_lensDireitoController.text) <= 0) {
        _lockCart(false);
        return _scaffoldKey.currentState.showSnackBar(
          invalidBoxes,
        );
      }
      if (_lensEsquerdoController.text == "" ||
          int.parse(_lensEsquerdoController.text) <= 0) {
        _lockCart(false);
        return _scaffoldKey.currentState.showSnackBar(
          invalidBoxes,
        );
      }
    } else {
      if (_lensController.text == "" || int.parse(_lensController.text) <= 0) {
        _lockCart(false);
        return _scaffoldKey.currentState.showSnackBar(
          invalidBoxes,
        );
      }
    }

    if (_numberController.text != "" &&
        Helper.cpfValidator(_numberController.text) != null) {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "CPF": ["CPF Invalido!"]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      _lockCart(false);
      return;
    }

    if (isValidDate(_birthdayController.text, context)) {
      _lockCart(false);
      return;
    }
    if (int.parse(_lensDireitoController.text) +
            int.parse(_lensEsquerdoController.text) +
            int.parse(_lensController.text) ==
        0) {
      _lockCart(false);
      return;
    }

    final errors = await _checkParameters(
        new Map<String, dynamic>.from(_first[_first['current']]),
        data['product'],
        new Map<String, dynamic>.from(_first));

    if (errors.keys.length <= 0) {
      int olhoDireito = int.parse(_lensDireitoController.text == ''
          ? '0'
          : _lensDireitoController.text);

      int olhoEsquerdo = int.parse(_lensEsquerdoController.text == ''
          ? '0'
          : _lensEsquerdoController.text);

      bool isSameEyes = _first['current'] == "Mesmo grau em ambos";

      int isSameQtd = int.parse(_lensController.text);

      Map<String, dynamic> _data = {
        '_cart_item': randomString(15),
        'quantity': _first['current'] == "Mesmo grau em ambos"
            ? int.parse(_lensController.text) * 2
            : _quantity,
        'quantity_for_eye': {
          'esquerdo': (isSameEyes || _first['current'] == 'Olho esquerdo')
              ? isSameQtd
              : olhoEsquerdo,
          'direito': (isSameEyes || _first['current'] == 'Olho direito')
              ? isSameQtd
              : olhoDireito,
        },
        'value': data['product'].value,
        'meta': meta,
        'tests': _first['test'],
        'operation': _parseOperation(widget.type),
        'product': data['product'],
        'type': _parseType(widget.type),
        'current': _first['current'],
        'codigoTeste': await _getProductCodeTest(_first),
        'pacient': {
          'name': _nameController.text,
          'number': _numberController.text,
          'birthday': _birthdayController.text,
        },
        _first['current']: _first[_first['current']],
      };
      if (_data['operation'] == "07" && _data["tests"] == "Sim" ||
          _data['operation'] == "01" && _data["tests"] == "Sim" ||
          _data['operation'] == "13" && _data["tests"] == "Sim") {
        int _currentTotal = _cartWidgetBloc.currentCartTotalItems;
        _cartWidgetBloc.cartTotalItemsSink.add(_currentTotal + 2);
      } else {
        int _currentTotal = _cartWidgetBloc.currentCartTotalItems;
        _cartWidgetBloc.cartTotalItemsSink.add(_currentTotal + 1);
      }

      _requestsBloc.addProductToCart(_data);
      if (typeButton == "onPurchase") {
        _lockCart(false);
        Modular.to.pushNamed(
            '/products/${currentProduct.product.id}/requestDetails',
            arguments: widget.type);
      } else {
        _lockCart(false);
        Modular.to.pushNamed("/cart/product");
      }
    } else {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
    }
    _lockCart(false);
  }

  _onBackToPurchase() {
    Modular.to.pushNamed("/home/0");
  }

  _cartParams(
    _first,
    meta,
  ) {
    var data = {'product': currentProduct.product};
    int olhoDireito = int.parse(
        _lensDireitoController.text == '' ? '0' : _lensDireitoController.text);

    int olhoEsquerdo = int.parse(_lensEsquerdoController.text == ''
        ? '0'
        : _lensEsquerdoController.text);

    int _quantity = int.parse(_lensDireitoController.text) +
        int.parse(_lensEsquerdoController.text) +
        int.parse(_lensController.text);

    bool isSameEyes = _first['current'] == "Mesmo grau em ambos";

    int isSameQtd = int.parse(_lensController.text);

    Map<String, dynamic> _data = {
      '_cart_item': randomString(15),
      'quantity': _first['current'] == "Mesmo grau em ambos"
          ? int.parse(_lensController.text) * 2
          : _quantity,
      'quantity_for_eye': {
        'esquerdo': (isSameEyes || _first['current'] == 'Olho esquerdo')
            ? isSameQtd
            : olhoEsquerdo,
        'direito': (isSameEyes || _first['current'] == 'Olho direito')
            ? isSameQtd
            : olhoDireito,
      },
      'value': data['product'].value,
      'meta': meta,
      'tests': _first['test'],
      'operation': _parseOperation(widget.type),
      'product': data['product'],
      'type': _parseType(widget.type),
      'current': _first['current'],
      'groupTest':  _first['groupTest'],
      'pacient': {
        'name': _nameController.text,
        'number': _numberController.text,
        'birthday': _birthdayController.text,
      },
      _first['current']: _first[_first['current']],
    };
    return _data;
  }
  _firstDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text("Erro no sistema!", style: TextStyle(color: Colors.red)),
            content: Text(
                'Algo deu errado, esse produto não existe. Por favor contate a Central.'),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Container(
                  // width: 20,
                  padding:const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 24, 22, 22),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Cancelar',
                    // style: TextStyle(fontSize: 24),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isProcessing = false;
                    _isLoadingPrimaryButton = false;
                    _isLoadingSecondButton = false;
                  });
                  Modular.to.pop();
                },
              ),
            ],
          );
        },
      );
      return;
  }

  _secondDialog(resp) {
    Dialogs.onlyConfirmbutton(context, onConfirm: () {
          Modular.to.pop();
        },
            info: Container(
              child: Column(children: [
                
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: resp['data']['index'].map<Widget>((e) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    // width: 260,
                                    child: Text(
                                      "${resp['data']['itens'][e - 1]['descricao']}",
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )
                            ],
                          );
                        }).toList())
                  ,
                Row(
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                    child: Row(
                      children: [
                        Icon(Icons.disc_full_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            "Codigo do produto: ${resp["data"]['itens'][0]["codigo"]}")
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ]),
            ),
            title: "OPSS!",
            subtitle: "Detectamos que esse parametro foi descontinuado e não será mais solicitado para reposição de estoque!!",
            confirmText: "Sair");
            return;
  }

  _thirdDialog(mode, resp) {
    Dialogs.confirmWithInfo(context, onCancel: () {
          setState(() {
            _isProcessing = false;
            _isLoadingPrimaryButton = false;
          });
          Modular.to.pop();
        }, onConfirm: () async {
          await _onAddToCart({'product': currentProduct.product}, mode,
              {'pendencie': true, 'days': resp["data"]["prazo"]});
        },
            info: Container(
              child: Column(children: [
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: resp['data']['index'].map<Widget>((e) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    // width: 260,
                                    child: Text(
                                      "${resp['data']['itens'][e - 1]['descricao']}",
                                      overflow: TextOverflow.visible,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )
                            ],
                          );
                        }).toList())
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/truck.png',
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            "Previsão de entrega ${resp['data']['prazo']} dias uteis")
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ]),
            ),
            title: "Pendencia",
            subtitle: "Falta de produto em estoque",
            confirmText: "Continuar",
            cancelText: "Cancelar");
            return;
  }

  _getProductCodeTest(obj) async {
    if (currentProduct.product.hasTest && obj['test'] == "Sim") {
      var result = await _productBloc.productCode(productCodeTestList(obj));
      return Map.from(result)['data'][0]['codigo']['codigo'];
    } else 
      return null;
  }

  _onPurchase(BuildContext context, ProductModel product, String mode) async {
    if (isValidDate(_birthdayController.text, context)) {
      return;
    }
    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;

    var result = await _productBloc.productCode(productCodeList(_first));
    _first = _putProductCode(_first, result);
    int itemQuantity =
        _productQuantity(_first['current'] == "Mesmo grau em ambos");
    if (_first['current'] == "Graus diferentes em cada olho") {
      
      if (!_first[_first['current']]['direito'].containsKey('codigo') && !_first[_first['current']]['esquerdo'].containsKey('codigo')) {
      _firstDialog();
      }
      var cartObject = _cartParams(_first, {});
      Map resp =
          // ignore: await_only_futures
          await _requestsBloc.checkStock({"itens": _updateQtdCart(cartObject)});
      for (var i = 0; i < resp["data"]['itens'].length; i ++) {
          if (resp["success"]) {
          if (resp["data"]['itens'][i]['saldo'] < 1 && resp["data"]['itens'][i]['descontinuado'] == 'S') {
            print('condição 1');
            return _secondDialog(resp);
          }
          
          if (resp["data"]["pendencia"] == true && resp["data"]['itens'][i]["saldo"] < 1 ) {
            print('condição 2');
            return _thirdDialog(mode, resp);
            
          } else {
          return await _onAddToCart({'product': currentProduct.product}, mode,
                {'pendencie': false, 'days': 0});
          }
        }
      }  
    } 
    if (!_first[_first['current']].containsKey('codigo') && _first['current'] != "Graus diferentes em cada olho") {
     _firstDialog();
    }
    var cartObject = _cartParams(_first, {});
    Map resp =
        // ignore: await_only_futures
        await _requestsBloc.checkStock({"itens": _updateQtdCart(cartObject)});
    if (resp["success"]) {
      if (resp["data"]['itens'][0]['saldo'] < 1 && resp["data"]['itens'][0]['descontinuado'] == 'S') {
        print('condição 1');
        _secondDialog(resp);
      }
      if (resp["data"]["pendencia"] == true &&  resp["data"]['itens'][0]["saldo"] < 1 ) {
        print('condição 2');
        _thirdDialog(mode, resp);
        
      } else {
        await _onAddToCart({'product': currentProduct.product}, mode,
            {'pendencie': false, 'days': 0});
      }
    }
    // await _onAddToCart({'product': currentProduct.product}, 'onPurchase');
  }

  List<Map> _renderButtonData(ProductModel product) {
    return [
      // {
      //   'color': Theme.of(context).accentColor,
      //   'textColor': Colors.white,
      //   'icon': Icon(
      //     MaterialCommunityIcons.plus,
      //     color: Colors.white,
      //   ),
      //   'onTap': _onPurchase,
      //   'text': 'Adicione e Continue Solicitando',
      // },
      {
        'color': Color(0xffF1F1F1),
        'textColor': Theme.of(context).accentColor,
        'icon': Icon(
          Icons.arrow_back,
          color: Theme.of(context).accentColor,
        ),
        'onTap': _onBackToPurchase,
        'text': 'Continue Comprando',
      },
      // {
      //   'color': Theme.of(context).primaryColor,
      //   'textColor': Colors.white,
      //   'icon': Image.asset(
      //     'assets/icons/cart.png',
      //     width: 20,
      //     height: 20,
      //     color: Colors.white,
      //   ),
      //   'onTap': () async {
      //     setState(() {
      //       _isLoading = true;
      //     });
      //     await _onAddToCart({
      //       'product': product,
      //     });
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   },
      //   'text': 'Adicionar ao Carrinho',
      // }
    ];
  }

  _verifyIcon() {
    if (widget.type == "A") {
      return CircleAvatar(
          backgroundColor: Color(0xfff),
          child: Image.asset(
            'assets/icons/credito-financeiro.png',
            width: 26,
            height: 26,
            color: Color(0xff707070),
          ));
    } else if (widget.type == "C") {
      return CircleAvatar(
          backgroundColor: Color(0xffEFC75E),
          child: Image.asset(
            'assets/icons/open_box.png',
            width: 20,
            height: 20,
            color: Colors.white,
          ));
    } else if (widget.type == "CF") {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(
            'assets/icons/credito-financeiro.png',
            width: 28,
            height: 28,
            color: Colors.green[300],
          ));
    } else if (widget.type == "T") {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.remove_red_eye,
            color: Colors.black54,
            size: 23,
          ));
    }
  }

  _getIcon(String type) {
    if (type == "A") {
      return CircleAvatar(
          backgroundColor: Color(0xfff),
          child: Image.asset(
            'assets/icons/credito-financeiro.png',
            width: 26,
            height: 26,
            color: Color(0xff707070),
          ));
    } else if (type == "C") {
      return CircleAvatar(
          backgroundColor: Color(0xffEFC75E),
          child: Image.asset(
            'assets/icons/open_box.png',
            width: 20,
            height: 20,
            color: Colors.white,
          ));
    } else if (type == "CF") {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(
            'assets/icons/credito-financeiro.png',
            width: 28,
            height: 28,
            color: Colors.green[300],
          ));
    } else if (type == "T") {
      return CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.remove_red_eye,
            color: Colors.black54,
            size: 23,
          ));
    }
  }

  _onAddCurrentParam(Map<dynamic, dynamic> data, BuildContext context) async {
    if (widget.type == "C") {
      if (data['current'] == 'Graus diferentes em cada olho' &&
          currentProduct.product.boxes < 2) {
        SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
          "Credito Insuficiente": [
            "Voce nao tem credito para comprar nessa modalidade"
          ]
        });
        _scaffoldKey.currentState.showSnackBar(
          _snack,
        );
      } else if (data['current'] == 'Graus diferentes em cada olho') {
        _lensDireitoController.text = '1';
        _lensEsquerdoController.text = '1';
        _lensController.text = '0';
        _onAddParam(data);
      } else {
        _lensDireitoController.text = '0';
        _lensEsquerdoController.text = '0';
        _lensController.text = '1';
        _onAddParam(data);
      }
    } else {
      if (data['current'] == 'Graus diferentes em cada olho') {
        _lensDireitoController.text = '1';
        _lensEsquerdoController.text = '1';
        _lensController.text = '0';
      } else {
        _lensDireitoController.text = '0';
        _lensEsquerdoController.text = '0';
        _lensController.text = '1';
      }
      _onAddParam(data);
    }
  }

  _onAddParam(Map<dynamic, dynamic> data) async {
    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;

    if (_first == null) {
      _productWidgetBloc.pacientInfoIn.add(data);
    } else {
      _productWidgetBloc.pacientInfoIn.add({
        ..._first,
        ...data,
      });
    }
  }

  _onChangedTest(dynamic value) {
    _hasTests = value;
    _onAddParam({'test': value});
  }

  _onSelectOption(
    Map<dynamic, dynamic> data,
    dynamic current, {
    String key,
  }) async {
    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;

    if (_first['current'] != 'Graus diferentes em cada olho') {
      await _onAddParam({
        await _first['current']: {
          ..._first[_first['current']],
          data['key']: current,
        }
      });
    } else {
      await _onAddParam({
        await _first['current']: {
          ..._first[_first['current']],
          key: {
            ..._first[_first['current']][key],
            data['key']: current,
          }
        }
      });
    }

    Modular.to.pop();
  }

  _onShowOptions(Map<dynamic, dynamic> data, {String key}) {
    Modals.params(
      context,
      items: data,
      onTap: (data, current) => _onSelectOption(data, current, key: key),
      title: data['labelText'],
    );
  }

  _pacienteInfo(BuildContext context) {
    Dialogs.pacienteInfo(context, onTap: () {
      Modular.to.pop();
    });
  }

  bool isValidDate(String input, BuildContext context) {
    SnackBar _snackBar;
    DateTime now = new DateTime.now();
    var splitDate = input.split("/");

    if (input == null || (input != null && input.isEmpty)) {
      return false;
    }

    if (int.parse(splitDate[2]) > (now.year - 18)) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }
    if (int.parse(splitDate[2]) <= 1900) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }

    var splitedDate = "${splitDate[2]}${splitDate[1]}${splitDate[0]}";

    final date = DateTime.parse(splitedDate);
    final originalFormatString = toOriginalFormatString(date);
    if (!(splitedDate == originalFormatString)) {
      _snackBar = SnackBar(
        content: Text(
          'Data de nascimento inválida.',
        ),
      );
    }
    if (_snackBar != null) {
      _scaffoldKey.currentState.showSnackBar(_snackBar);
      return true;
    }
    return false;
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = MaskedTextController(
      mask: '000.000.000-00',
    );

    _isLoadingSecondButton = false;
    _isLoadingPrimaryButton = false;

    _lensController = TextEditingController(
      text: '1',
    );
    _lensEsquerdoController = TextEditingController(
      text: '0',
    );
    _lensDireitoController = TextEditingController(
      text: '0',
    );

    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );

    currentProduct = _productBloc.currentProduct;

    _fieldData = [
      {
        'labelText': 'Nome do paciente',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Escolha os olhos',
        'icon': MaterialCommunityIcons.eye,
        'key': 'eyes',
      },
    ];

    _productBloc.fetchParametros(currentProduct.product.group);

    _productWidgetBloc.resetPacientInfo();

    _lensController.addListener(() {
      validateLensQuantity("ambos");
    });

    _lensDireitoController.addListener(() {
      validateLensQuantity("direito");
    });

    _lensEsquerdoController.addListener(() {
      validateLensQuantity("esquerdo");
    });

    _isProcessing = false;
  }

  void validateLensQuantity(String type) async {
    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;

    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();

    int _quantity = int.parse(_lensDireitoController.text == ''
            ? '0'
            : _lensDireitoController.text) +
        int.parse(_lensEsquerdoController.text == ''
            ? '0'
            : _lensEsquerdoController.text) +
        int.parse(_lensController.text == '' ? '0' : _lensController.text);

    int _qtd = _first['current'] == "Mesmo grau em ambos"
        ? int.parse(_lensController.text == '' ? '0' : _lensController.text) * 2
        : _quantity;
    if (_authBloc.getAuthCurrentUser.data.money <
            ((_qtd * currentProduct.product.valueFinan) +
                _cartTotalFinancial) &&
        widget.type == "CF") {
      _showDialog("Limite atingido.",
          "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
      setState(() {
        if (type == "esquerdo") _lensEsquerdoController.text = '';
        if (type == "direito") _lensDireitoController.text = '';
        if (type == "ambos") _lensController.text = '';
      });
    } else if (widget.type == "C") {
      if (currentProduct.product.boxes < _qtd + cartTotal) {
        _showDialog("Limite atingido.",
            "Você possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        setState(() {
          if (type == "esquerdo") _lensEsquerdoController.text = '';
          if (type == "direito") _lensDireitoController.text = '';
          if (type == "ambos") _lensController.text = '';
        });
      }
    } else if (currentProduct.product.tests < _qtd + _cartTotalTest &&
        widget.type == "T") {
      _showDialog("Limite atingido.",
          "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
      setState(() {
        if (type == "esquerdo") _lensEsquerdoController.text = '';
        if (type == "direito") _lensDireitoController.text = '';
        if (type == "ambos") _lensController.text = '';
      });
    }
  }

  List<Map<String, dynamic>> generateProductParams(Parametros parametro) {
    return [
      {
        'labelText': 'Escolha o Grau',
        'key': 'degree',
        'items': parametro.parametro.grausEsferico,
        'enabled': currentProduct.product.hasEsferico
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'key': 'cylinder',
        'items': parametro.parametro.grausCilindrico,
        'enabled': currentProduct.product.hasCilindrico
      },
      {
        'labelText': 'Escolha o Eixo',
        'key': 'axis',
        'items': parametro.parametro.grausEixo,
        'enabled': currentProduct.product.hasEixo
      },
      {
        'labelText': 'Escolha a Adicao',
        'key': 'adicao',
        'items': parametro.parametro.grausAdicao,
        'enabled': currentProduct.product.hasAdicao
      },
      {
        'labelText': 'Escolha a Cor',
        'key': 'cor',
        'items': parametro.parametro.cor,
        'enabled': currentProduct.product.hasCor
      }
    ];
  }

  Widget _getValueLabel(String type) {
    return Column(children: [
      Container(
        padding: EdgeInsets.only(top: 8),
        height: 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _getIcon(type),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                _getType(type),
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.black45,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _priceTable(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
//            decoration: BoxDecoration(
//              border: Border.all(color: Theme.of(context).accentColor.withOpacity(0.3)),
//              borderRadius: BorderRadius.all(Radius.circular(5))
//            ),
      width: 30,
      child: Column(
        children: [
          Text(
            "Tabela de Preços",
            style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Table(
            children: [
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text(
                        "${_getBuyValue("A")}",
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: _getValueLabel("A"),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text("${_getBuyValue("C")}",
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: _getValueLabel("C"),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text("${_getBuyValue("CF")}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: _getValueLabel("CF"),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Text("---"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: _getValueLabel("T"),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('testee');
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do Pedido'),
          centerTitle: false,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 40, top: 5),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart,
                      size: 40, color: Colors.green[300]),
                  onPressed: () {
                    Modular.to.pushNamed("/cart/product");
                  },
                ))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ProductProfileWidget(
                        value: currentProduct.product.value,
                        title: currentProduct.product.title,
                        tests: currentProduct.product.tests -
                            _calculateCreditTest(),
                        imageUrl: currentProduct.product.imageUrl,
                        credits: currentProduct.product.boxes,
                        screen: 'request_details_screen',
                        onTap: () async {},
                      ),
                      //                    CachedNetworkImage(
                      //                      errorWidget: (context, url, error) =>
                      //                          Image.asset('assets/images/no_image_product.jpeg'),
                      //                      imageUrl: currentProduct.product.imageUrl,
                      //                      width: 120,
                      //                      height: 100,
                      //                      alignment: Alignment.center,
                      //                      fit: BoxFit.contain,
                      //                    ),

                      //   Text("${_getBuyValue(widget.type)}", style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 17),)
                    ]),
                SizedBox(width: 20),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Produto',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black38,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text('${currentProduct.product.title}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        Text(
                          "Modo de compra",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).primaryColor),
                        ),
                        _getValueLabel(widget.type)
                      ],
                    )
                  ],
                )),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 50,
              thickness: 0.2,
              color: Color(0xffa1a1a1),
            ),
            Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: AutoSizeText(
                        'Informações do Paciente',
                        // textScaleFactor: 1.10,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          size: 30,
                        ),
                        onPressed: () {
                          _pacienteInfo(context);
                        },
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 10),
            Text(
              'Preenchendo o nome você obterá o controle para o periodo de reavaliação do paciente.',
              style: Theme.of(context).textTheme.subtitle1,
              // textScaleFactor: 1.25,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Column(
              children: _fieldData.take(1).map(
                (e) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: TextFieldWidget(
                      labelText: e['labelText'],
                      prefixIcon: Icon(
                        e['icon'],
                        color: Color(0xffa1a1a1),
                      ),
                      controller: e['controller'],
                      validator: e['validator'],
                      keyboardType: e['keyboardType'],
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Parâmetros',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            _accessory(FittedBox(
              fit: BoxFit.contain,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        !currentProduct.product.hasAcessorio
                            ? 'Quantidade de caixas'
                            : 'Quantidade',
                        style: Theme.of(context).textTheme.subtitle1),
                    TextFieldWidget(
                      width: 150,
                      controller: _lensController,
                      readOnly: false,
                      focus: caixasFocus,
                      keyboardType: TextInputType.number,
                      inputFormattersActivated: true,
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Colors.black26,
                          size: 30,
                        ),
                        onPressed: _onRemoveLens,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.black26,
                          size: 30,
                        ),
                        onPressed: _onAddLens,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            _checkForAcessorio(Text(
              'Defina os parâmetros do produto',
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )),
            SizedBox(height: 30),
            _checkForAcessorio(StreamBuilder<Map<dynamic, dynamic>>(
              stream: _productWidgetBloc.pacientInfoOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _checkForAcessorio(InputDecorator(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    labelText: 'Escolha os olhos',
                    labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Color(0xffA1A1A1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: DropdownButton(
                        value: snapshot.data['current'],
                        items: [
                          'Olho direito',
                          'Olho esquerdo',
                          'Mesmo grau em ambos',
                          'Graus diferentes em cada olho',
                        ].map(
                          (e) {
                            return DropdownMenuItem(
                              child: FittedBox(
                                  fit: BoxFit.contain, child: Text('$e')),
                              value: e,
                            );
                          },
                        ).toList(),
                        onChanged: (value) => _onAddCurrentParam({
                          'current': value,
                        }, context),
                      ),
                    ),
                  ),
                )
                    //   DropdownWidget(
                    //   labelText: 'Escolha os olhos',
                    //   items: [
                    //     'Olho direito',
                    //     'Olho esquerdo',
                    //     'Mesmo grau em ambos',
                    //     'Graus diferentes em cada olho',
                    //   ],
                    //   onChanged: (value) => _onAddCurrentParam({
                    //     'current': value,
                    //   }),
                    //   currentValue: snapshot.data['current'],
                    // )
                    );
              },
            )),
            _checkForAcessorio(SizedBox(height: 20)),
            _checkForAcessorio(StreamBuilder<Map<dynamic, dynamic>>(
              stream: _productWidgetBloc.pacientInfoOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data['current'] !=
                    'Graus diferentes em cada olho') {
                  return Column(
                    children: <Widget>[
                      _checkForAcessorio(Text(
                        '${snapshot.data['current']}',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      )),
                      SizedBox(height: 30),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  !currentProduct.product.hasAcessorio
                                      ? 'Quantidade de caixas'
                                      : 'Quantidade',
                                  style: Theme.of(context).textTheme.subtitle1),
                              TextFieldWidget(
                                width: 150,
                                controller: _lensController,
                                readOnly: false,
                                focus: caixasFocus,
                                keyboardType: TextInputType.number,
                                inputFormattersActivated: true,
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.black26,
                                    size: 30,
                                  ),
                                  onPressed: _onRemoveLens,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black26,
                                    size: 30,
                                  ),
                                  onPressed: _onAddLens,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      StreamBuilder(
                          stream: _productBloc.parametroListStream,
                          builder: (context, parametroSnapshot) {
                            if (!parametroSnapshot.hasData ||
                                parametroSnapshot.data.isLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final _productParams =
                                generateProductParams(parametroSnapshot.data);

                            return ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _productParams.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                return _productParams[index]['enabled']
                                    ? TextFieldWidget(
                                        readOnly: true,
                                        suffixIcon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(0xffa1a1a1),
                                        ),
                                        controller: TextEditingController()
                                          ..text =
                                              "${snapshot.data[snapshot.data['current']][_productParams[index]['key']].toString()}",
                                        labelText: _productParams[index]
                                            ['labelText'],
                                        onTap: () => _onShowOptions(
                                          _productParams[index],
                                        ),
                                      )
                                    : Container();
                              },
                            );
                          }),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _checkForAcessorio(Text(
                            'Olho direito',
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(height: 30),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    !currentProduct.product.hasAcessorio
                                        ? 'Quantidade de caixas'
                                        : 'Quantidade',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: TextFieldWidget(
                                    width: 120,
                                    controller: _lensDireitoController,
                                    readOnly: false,
                                    focus: caixasOlhoDireitoFocus,
                                    keyboardType: TextInputType.number,
                                    inputFormattersActivated: true,
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: Colors.black26,
                                        size: 30,
                                      ),
                                      onPressed: _onRemoveLensDireito,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black26,
                                        size: 30,
                                      ),
                                      onPressed: _onAddLensDireito,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: _productBloc.parametroListStream,
                              builder: (context, parametroSnapshot) {
                                if (!parametroSnapshot.hasData ||
                                    parametroSnapshot.data.isLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                final _productParams = generateProductParams(
                                    parametroSnapshot.data);

                                return ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: _productParams.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return _productParams[index]['enabled']
                                        ? TextFieldWidget(
                                            readOnly: true,
                                            suffixIcon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xffa1a1a1),
                                            ),
                                            controller: TextEditingController()
                                              ..text =
                                                  "${snapshot.data['Graus diferentes em cada olho']['direito'][_productParams[index]['key']].toString()}",
                                            labelText: _productParams[index]
                                                ['labelText'],
                                            onTap: () => _onShowOptions(
                                              _productParams[index],
                                              key: 'direito',
                                            ),
                                          )
                                        : Container();
                                  },
                                );
                              }),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: <Widget>[
                          _checkForAcessorio(Text(
                            'Olho esquerdo',
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          )),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                !currentProduct.product.hasAcessorio
                                    ? 'Quantidade de caixas'
                                    : 'Quantidade',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              TextFieldWidget(
                                width: 120,
                                controller: _lensEsquerdoController,
                                readOnly: false,
                                focus: caixasOlhoEsquerdoFocus,
                                keyboardType: TextInputType.number,
                                inputFormattersActivated: true,
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.black26,
                                    size: 30,
                                  ),
                                  onPressed: _onRemoveLensEsquerdo,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black26,
                                    size: 30,
                                  ),
                                  onPressed: _onAddLensEsquerdo,
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: _productBloc.parametroListStream,
                              builder: (context, parametroSnapshot) {
                                if (!parametroSnapshot.hasData ||
                                    parametroSnapshot.data.isLoading) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                final _productParams = generateProductParams(
                                    parametroSnapshot.data);

                                return ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: _productParams.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    print(_productParams[index]['key']);
                                    return _productParams[index]['enabled']
                                        ? TextFieldWidget(
                                            readOnly: true,
                                            suffixIcon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color(0xffa1a1a1),
                                            ),
                                            controller: TextEditingController()
                                              ..text =
                                                  "${snapshot.data['Graus diferentes em cada olho']['esquerdo'][_productParams[index]['key']].toString()}",
                                            labelText: _productParams[index]
                                                ['labelText'],
                                            onTap: () => _onShowOptions(
                                              _productParams[index],
                                              key: 'esquerdo',
                                            ),
                                          )
                                        : Container();
                                  },
                                );
                              }),
                        ],
                      ),
                    ],
                  );
                }
              },
            )),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 10),
            currentProduct.product.hasTest && widget.type != "T" && currentProduct.product.tests > 0 || (widget.type == 'A' && currentProduct.product.hasTest)
                ? _checkForAcessorio(StreamBuilder<Map>(
                    stream: _productWidgetBloc.pacientInfoOut,
                    builder: (context, snapshot) {
                      if (widget.type == 'CF' && _hasTests == 'Não') {
                        _hasTests = "Sim";
                        _onAddParam({'test': 'Sim'});
                      }
                      print('dados snapshot');
                      print(currentProduct.product);
                      print(snapshot.data);
                      return DropdownWidget(
                          items: ['Não', 'Sim'],
                          currentValue:
                              snapshot.hasData ? snapshot.data['test'] : null,
                          labelText: 'Teste?',
                          onChanged: _onChangedTest);
                    },
                  ))
                : Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        ListTileMoreCustomizable(
                          contentPadding: const EdgeInsets.all(0),
                          horizontalTitleGap: 0,
                          leading: Image.asset(
                            'assets/icons/map_marker.png',
                            width: 25,
                            height: 25,
                          ),
                          title: Text(
                            'Endereço de Entrega',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                          subtitle: Text(
                            '${currentProduct.product.enderecoEntrega}',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 30,
                    color: Color(0xffF1F1F1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/truck.png',
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(width: 10),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Entrega prevista em ${currentProduct.product.previsaoEntrega} dias',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 16,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: !_isLoadingPrimaryButton
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).accentColor, elevation: 0),
                      icon: Icon(
                        MaterialCommunityIcons.plus,
                        color: Colors.white,
                      ),
                      onPressed: !_isProcessing
                          ? () async {
                              setState(() {
                                _isLoadingPrimaryButton = true;
                                _isProcessing = true;
                              });
                              await _onPurchase(
                                  context, widget.product, 'onPurchase');
                              setState(() {
                                _isProcessing = false;
                                _isLoadingPrimaryButton = false;
                              });
                            }
                          : null,
                      label: FittedBox(
                        fit: BoxFit.contain,
                        child: AutoSizeText(
                          'Adicione e Continue Solicitando',
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white,
                              fontSize: _verifyFontSize2()),
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _renderButtonData(currentProduct.product).map(
                  (e) {
                    return Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: e['color'], elevation: 0),
                          icon: e['icon'],
                          onPressed: e['onTap'],
                          label: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              e['text'] ?? "-",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: e['textColor'],
                                      fontSize: _verifyFontSize()),
                            ),
                          ),
                        ));
                  },
                ).toList()),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: !_isLoadingSecondButton
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 0),
                      icon: Image.asset(
                        'assets/icons/cart.png',
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                      onPressed: !_isProcessing
                          ? () async {
                              setState(() {
                                _isLoadingSecondButton = true;
                                _isProcessing = true;
                              });
                              log("${currentProduct.product.value}");

                              await _onPurchase(
                                  context, widget.product, 'Normal');
                              setState(() {
                                _isProcessing = false;
                                _isLoadingSecondButton = false;
                              });
                            }
                          : null,
                      label: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Adicionar ao Carrinho',
                          style: Theme.of(context).textTheme.button.copyWith(
                              color: Colors.white, fontSize: _verifyFontSize()),
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
