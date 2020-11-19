import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
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

class RequestDetailsScreen extends StatefulWidget {
  int id;
  String type;
  ProductModel product;
  RequestDetailsScreen({this.id, this.type = 'Avulso', this.product});

  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> _productParams;
  List<Map> _fieldData;
  TextEditingController _nameController;
  TextEditingController _lensDireitoController;
  TextEditingController _lensEsquerdoController;
  TextEditingController _lensController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;
  Product currentProduct;

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

  _onAddLens() {
    int cartTotal = _calculateCreditProduct();

    if (widget.type == "C") {
      int olho = int.parse(_lensController.text);
      if (currentProduct.product.boxes > olho + cartTotal) {
        _lensController.text = '${int.parse(_lensController.text) + 1}';
      } else {
        SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
          "Limite atingido": ["Limite de caixas atingido"]
        });
        _scaffoldKey.currentState.showSnackBar(
          _snack,
        );
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

    if (widget.type == "C") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (currentProduct.product.boxes >
          olhoDireito + olhoEsquerdo + cartTotal) {
        _lensDireitoController.text =
            '${int.parse(_lensDireitoController.text) + 1}';
      } else {
        SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
          "Limite atingido": ["Limite de caixas atingido"]
        });
        _scaffoldKey.currentState.showSnackBar(
          _snack,
        );
      }
    } else {
      _lensDireitoController.text =
          '${int.parse(_lensDireitoController.text) + 1}';
    }
  }

  _onAddLensEsquerdo() {
    int cartTotal = _calculateCreditProduct();

    if (widget.type == "C") {
      int olhoDireito = int.parse(_lensDireitoController.text);
      int olhoEsquerdo = int.parse(_lensEsquerdoController.text);
      if (currentProduct.product.boxes >
          olhoDireito + olhoEsquerdo + cartTotal) {
        _lensEsquerdoController.text =
            '${int.parse(_lensEsquerdoController.text) + 1}';
      } else {
        SnackBar _snack = ErrorSnackBar.snackBar(this.context, {
          "Limite atingido": ["Limite de caixas atingido"]
        });
        _scaffoldKey.currentState.showSnackBar(
          _snack,
        );
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
                    key = "Eixo ${olho}";
                    break;
                  case "cylinder":
                    key = "Cilindro ${olho}";
                    break;
                  case "degree":
                    key = "Esferico ${olho}";
                    break;
                  case "cor":
                    key = "Cor ${olho}";
                    break;
                  case "adicao":
                    key = "Adicao ${olho}";
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

  _onAddToCart(Map data) async {
    if (int.parse(_lensDireitoController.text) +
            int.parse(_lensEsquerdoController.text) +
            int.parse(_lensController.text) ==
        0) {
      return;
    }

    Map<dynamic, dynamic> _first =
        await _productWidgetBloc.pacientInfoOut.first;
    final errors = await _checkParameters(
        new Map<String, dynamic>.from(_first[_first['current']]),
        data['product'],
        new Map<String, dynamic>.from(_first));

    if (errors.keys.length <= 0) {
      Map<String, dynamic> _data = {
        '_cart_item': randomString(15),
        'quantity': int.parse(_lensDireitoController.text) +
            int.parse(_lensEsquerdoController.text) +
            int.parse(_lensController.text),
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
      _requestsBloc.addProductToCart(_data);
      Modular.to.pushNamed("/cart/product");
    } else {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
    }
    // print(_data);
  }

  _onBackToPurchase() {
    Modular.to.pushNamed("/home/0");
  }

  _onPurchase() async {
    await _onAddToCart({'product': currentProduct.product});
    Modular.to.pushNamed(
      '/products/${widget.id}/requestDetails',
      arguments: widget.type,
    );
  }

  List<Map> _renderButtonData(ProductModel product) {
    return [
      {
        'color': Theme.of(context).accentColor,
        'textColor': Colors.white,
        'icon': Icon(
          MaterialCommunityIcons.plus,
          color: Colors.white,
        ),
        'onTap': _onPurchase,
        'text': 'Comprar Mesmo Produto',
      },
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
      {
        'color': Theme.of(context).primaryColor,
        'textColor': Colors.white,
        'icon': Image.asset(
          'assets/icons/cart.png',
          width: 20,
          height: 20,
          color: Colors.white,
        ),
        'onTap': () {
          _onAddToCart({
            'product': product,
          });
        },
        'text': 'Adicionar ao Carrinho',
      }
    ];
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();

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
        'labelText': 'Número do Cliente',
        'icon': MaterialCommunityIcons.numeric,
        'controller': _numberController,
        'keyboardType': TextInputType.number,
      },
      {
        'labelText': 'Data de Nascimento',
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
                    Text(
                      'R\$ ${Helper.intToMoney(currentProduct.product.value)}',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ]),
              SizedBox(width: 20),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Produto',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text('${currentProduct.product.title}',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 40),
                  Container(
                    height: 30,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color(0xffEFC75E),
                          child: Image.asset(
                            'assets/icons/open_box.png',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Produto',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: Colors.black45,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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
          Text(
            'Informações do Paciente',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Categorizando seus pedidos por paciente, enviaremos um alerta com o período para reavaliação. Você também acumulara pontos para compras futuras!',
            style: Theme.of(context).textTheme.subtitle1,
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
              return _checkForAcessorio(DropdownWidget(
                labelText: 'Escolha os olhos',
                items: [
                  'Olho direito',
                  'Olho esquerdo',
                  'Mesmo grau em ambos',
                  'Graus diferentes em cada olho',
                ],
                onChanged: (value) => _onAddCurrentParam({
                  'current': value,
                }),
                currentValue: snapshot.data['current'],
              ));
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
                              controller: _lensDireitoController,
                              readOnly: false,
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
                          ],
                        )
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
                        )
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
          StreamBuilder(
              stream: _productWidgetBloc.pacientInfoOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                if (snapshot.data['current'] !=
                    'Graus diferentes em cada olho') {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        !currentProduct.product.hasAcessorio
                            ? 'Quantidade de caixas'
                            : 'Quantidade',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextFieldWidget(
                        width: 150,
                        controller: _lensController,
                        readOnly: false,
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
                  );
                } else {
                  return Container();
                }
              }),
          SizedBox(height: 10),
          currentProduct.product.hasTest && currentProduct.product.tests > 0
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
                      Text(
                        'Entrega prevista em ${currentProduct.product.previsaoEntrega} dias',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  label: Text(
                    e['text'] ?? "-",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: e['textColor'],
                        ),
                  ),
                ),
              );
            },
          ).toList())
        ],
      ),
    );
  }
}
