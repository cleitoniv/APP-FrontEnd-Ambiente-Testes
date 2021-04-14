import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:random_string/random_string.dart';
import 'package:sizer/sizer.dart';

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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  int _calculateCreditProduct() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;

    int _total = _cart.fold(0, (previousValue, element) {
      if (element["operation"] == "07" &&
          element['product'].group == currentProduct.product.group) {
        return previousValue + element['quantity'];
      }
      return previousValue;
    });
    return _total;
  }

  int _calculateCreditFinancial() {
    List<Map<String, dynamic>> _cart = _requestsBloc.cartItems;
    int _total = _cart.fold(0, (previousValue, element) {
      if (element["operation"] == "13") {
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
      if (element["operation"] == "00" &&
          element['product'].group == currentProduct.product.group) {
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
            RaisedButton(
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

    if (widget.type == "C") {
      int olho = int.parse(_lensController.text);
      if (currentProduct.product.boxes > olho + cartTotal) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "T") {
      int olho = int.parse(_lensController.text);
      if (currentProduct.product.tests > olho + _cartTotalTest) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "CF") {
      int olho = int.parse(_lensController.text);
      if (_authBloc.getAuthCurrentUser.data.money >
          olho * currentProduct.product.valueFinan + _cartTotalFinancial) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
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
    if (widget.type == "C") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (currentProduct.product.boxes >
          olhoDireito + olhoEsquerdo + cartTotal) {
        _lensDireitoController.text =
            '${int.parse(_lensDireitoController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "O limite de caixa estorou. Voce possui menos que a quantidade selecionada, verifique se contém caixas a mais no carrinho.");
        return _lensDireitoController.text = "1";
      }
    } else if (widget.type == "T") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (currentProduct.product.tests >
          olhoDireito + olhoEsquerdo + _cartTotalTest) {
        _lensDireitoController.text =
            '${int.parse(_lensDireitoController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "O limite de caixa estorou. Voce possui menos que a quantidade selecionada, verifique se contém caixas a mais no carrinho.");
        return _lensController.text = "1";
      }
    } else if (widget.type == "CF") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (_authBloc.getAuthCurrentUser.data.money >
          (olhoEsquerdo + olhoDireito) * currentProduct.product.valueFinan +
              _cartTotalFinancial) {
        _lensDireitoController.text =
            '${int.parse(_lensDireitoController.text) + 1}';
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

    if (widget.type == "C") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
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
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (currentProduct.product.tests >
          olhoDireito + olhoEsquerdo + _cartTotalTest) {
        _lensEsquerdoController.text =
            '${int.parse(_lensEsquerdoController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensEsquerdoController.text = "1";
      }
    } else if (widget.type == "CF") {
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      int olhoDireito = int.parse(_lensDireitoController.text);
      if (_authBloc.getAuthCurrentUser.data.money >
          (olhoDireito + olhoEsquerdo) * currentProduct.product.valueFinan +
              _cartTotalFinancial) {
        _lensEsquerdoController.text =
            '${int.parse(_lensEsquerdoController.text) + 1}';
      } else {
        _showDialog("Limite atingido.",
            "Voce possui menos que a quantidade selecionada, verifique se contém produtos com caixas a mais no carrinho.");
        return _lensEsquerdoController.text = "1";
      }
    } else {
      _lensEsquerdoController.text =
          '${int.parse(_lensEsquerdoController.text) + 1}';
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

  String _parseType(String type) {
    return type == "CF" ? "A" : type;
  }

  String _parseOperation(String type) {
    if (type == "C") {
      return "07";
    } else if (type == "CF") {
      return "13";
    } else {
      return "01";
    }
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
      "adicao": product.hasAdicao ?? false
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
              key = "Esferico";
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

  _onAddToCart(Map data, String typeButton) async {
    int cartTotal = _calculateCreditProduct();
    int _cartTotalTest = _calculateCreditTest();
    int _cartTotalFinancial = _calculateCreditFinancial();

    var invalidBoxes = SnackBar(
        content: Text("Quantidade de caixas tem que ser maior que 0."));

    Map<dynamic, dynamic> _checkTypeLens =
        await _productWidgetBloc.pacientInfoOut.first;

    if (_checkTypeLens['current'] == "Graus diferentes em cada olho") {
      if (_lensDireitoController.text == "" ||
          int.parse(_lensDireitoController.text) <= 0) {
        return _scaffoldKey.currentState.showSnackBar(
          invalidBoxes,
        );
      }
      if (_lensEsquerdoController.text == "" ||
          int.parse(_lensEsquerdoController.text) <= 0) {
        return _scaffoldKey.currentState.showSnackBar(
          invalidBoxes,
        );
      }
    } else {
      if (_lensController.text == "" || int.parse(_lensController.text) <= 0) {
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
      return;
    }

    if (isValidDate(_birthdayController.text)) {
      return;
    }
    if (int.parse(_lensDireitoController.text) +
            int.parse(_lensEsquerdoController.text) +
            int.parse(_lensController.text) ==
        0) {
      return;
    }
    if (currentProduct.product.boxes <
            int.parse(_lensController.text) + cartTotal &&
        widget.type == "C") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (currentProduct.product.tests <
            int.parse(_lensController.text) + _cartTotalTest &&
        widget.type == "T") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (_authBloc.getAuthCurrentUser.data.money <
            (int.parse(_lensController.text) *
                    currentProduct.product.valueFinan) +
                _cartTotalFinancial &&
        widget.type == "CF") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Seu saldo é inferior a quantidade desejada."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    }

    if (currentProduct.product.boxes <
            int.parse(_lensEsquerdoController.text) +
                cartTotal +
                int.parse(_lensDireitoController.text) &&
        widget.type == "C") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (currentProduct.product.tests <
            int.parse(_lensEsquerdoController.text) +
                _cartTotalTest +
                int.parse(_lensDireitoController.text) &&
        widget.type == "T") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (_authBloc.getAuthCurrentUser.data.money <
            ((int.parse(_lensEsquerdoController.text) +
                        int.parse(_lensDireitoController.text)) *
                    currentProduct.product.valueFinan) +
                _cartTotalFinancial &&
        widget.type == "CF") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Seu saldo é inferior a quantidade desejada."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    }

    if (currentProduct.product.boxes <
            int.parse(_lensDireitoController.text) +
                cartTotal +
                int.parse(_lensEsquerdoController.text) &&
        widget.type == "C") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (currentProduct.product.tests <
            int.parse(_lensDireitoController.text) +
                _cartTotalTest +
                int.parse(_lensEsquerdoController.text) &&
        widget.type == "T") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Limite de caixas atingido."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    } else if (_authBloc.getAuthCurrentUser.data.money <
            ((int.parse(_lensEsquerdoController.text) +
                        int.parse(_lensDireitoController.text)) *
                    currentProduct.product.valueFinan) +
                _cartTotalFinancial &&
        widget.type == "CF") {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
        "Limite Atingido": ["Seu saldo é inferior a quantidade desejada."]
      });
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    }

    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;

    final errors = await _checkParameters(
        new Map<String, dynamic>.from(_first[_first['current']]),
        data['product'],
        new Map<String, dynamic>.from(_first));

    if (errors.keys.length <= 0) {
      int _quantity = int.parse(_lensDireitoController.text) +
          int.parse(_lensEsquerdoController.text) +
          int.parse(_lensController.text);

      Map<String, dynamic> _data = {
        '_cart_item': randomString(15),
        'quantity': _first['current'] == "Mesmo grau em ambos"
            ? int.parse(_lensController.text) * 2
            : _quantity,
        'quantity_for_eye': {
          'esquerdo': int.parse(_lensEsquerdoController.text),
          'direito': int.parse(_lensDireitoController.text)
        },
        'tests': _first['test'],
        'operation': _parseOperation(widget.type),
        'product': data['product'],
        'type': _parseType(widget.type),
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
        Modular.to.pushNamed(
            '/products/${currentProduct.product.id}/requestDetails',
            arguments: widget.type);
      } else {
        Modular.to.pushNamed("/cart/product");
      }
    } else {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
    }
  }

  _onBackToPurchase() {
    Modular.to.pushNamed("/home/0");
  }

  _onPurchase() async {
    if (isValidDate(_birthdayController.text)) {
      return;
    }

    await _onAddToCart({'product': currentProduct.product}, 'onPurchase');
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

  _onAddCurrentParam(Map<dynamic, dynamic> data) async {
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

  bool isValidDate(String input) {
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
        'labelText': 'CPF(opcional)',
        'icon': MaterialCommunityIcons.numeric,
        'controller': _numberController,
        'keyboardType': TextInputType.number,
        'validator': Helper.cpfValidator
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'controller': _birthdayController,
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Escolha os olhos',
        'icon': MaterialCommunityIcons.eye,
        'key': 'eyes',
      },
    ];

    _productBloc.fetchParametros(currentProduct.product.group);

    _productWidgetBloc.resetPacientInfo();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    CachedNetworkImage(
                      imageUrl: currentProduct.product.imageUrl,
                      width: 120,
                      height: 100,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        _verifyBuy(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    ),
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
                  Container(
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _verifyIcon(),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            _verifyType(),
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.black45,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
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
                      textScaleFactor: 1.10,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.help_outline,
                      size: 30,
                    ),
                    onPressed: () {
                      _pacienteInfo(context);
                    },
                  ),
                ],
              )),
          SizedBox(height: 10),
          Text(
            'Gestão do Paciente & Pontos Controle o período para reavaliação do seu paciente preenchendo o nome e a data de nascimento, opcionalmente completando com o CPF dele, voce acumula pontos para compras futuras.',
            style: Theme.of(context).textTheme.subtitle1,
            textScaleFactor: 1.25,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Column(
            children: _fieldData.take(3).map(
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
          _checkForAcessorio(Text(
            'Parâmetros',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          )),
          _checkForAcessorio(SizedBox(height: 10)),
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
                      }),
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
                                  style: Theme.of(context).textTheme.subtitle1,
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
          currentProduct.product.hasTest && widget.type != "T"
              ? _checkForAcessorio(StreamBuilder<Map>(
                  stream: _productWidgetBloc.pacientInfoOut,
                  builder: (context, snapshot) {
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
                          style: Theme.of(context).textTheme.headline5.copyWith(
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
                          style: Theme.of(context).textTheme.headline5.copyWith(
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
                ? RaisedButton.icon(
                    icon: Icon(
                      MaterialCommunityIcons.plus,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).accentColor,
                    elevation: 0,
                    onPressed: () async {
                      setState(() {
                        _isLoadingPrimaryButton = true;
                      });
                      await _onPurchase();
                      setState(() {
                        _isLoadingPrimaryButton = false;
                      });
                    },
                    label: FittedBox(
                      fit: BoxFit.contain,
                      child: AutoSizeText(
                        'Adicione e Continue Solicitando',
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.white, fontSize: _verifyFontSize2()),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Column(
              children: _renderButtonData(currentProduct.product).map(
            (e) {
              return Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: RaisedButton.icon(
                    icon: e['icon'],
                    color: e['color'],
                    elevation: 0,
                    onPressed: e['onTap'],
                    label: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        e['text'] ?? "-",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                            color: e['textColor'], fontSize: _verifyFontSize()),
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
                ? RaisedButton.icon(
                    icon: Image.asset(
                      'assets/icons/cart.png',
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                    color: Theme.of(context).primaryColor,
                    elevation: 0,
                    onPressed: () async {
                      setState(() {
                        _isLoadingSecondButton = true;
                      });
                      await _onAddToCart({
                        'product': currentProduct.product,
                      }, 'Normal');
                      setState(() {
                        _isLoadingSecondButton = false;
                      });
                    },
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
    );
  }
}
