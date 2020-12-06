import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/modals.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();
  List<Map> _pacientInfo;
  List<Map> _productParams;
  TextEditingController _nameController;
  TextEditingController _numberController;
  TextEditingController _olhoController;
  MaskedTextController _birthdayController;
  TextEditingController _lensController;
  TextEditingController _degreeController;
  TextEditingController _cylinderController;
  TextEditingController _axisController;
  TextEditingController _corController;
  TextEditingController _adicaoController;
  Map<String, dynamic> hasParams;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _onChangeParams(Map<String, dynamic> data,
      {String key, current, param}) async {
    switch (param) {
      case 'degree':
        _degreeController.text = "$current";
        break;
      case 'cylinder':
        _cylinderController.text = "$current";
        break;
      case 'axis':
        _axisController.text = "$current";
        break;
      case 'cor':
        _corController.text = "$current";
        break;
      case 'adicao':
        _adicaoController.text = "$current";
        break;
    }

    if (_degreeController.text != "" &&
        _cylinderController.text != "" &&
        _axisController.text != "" &&
        _corController.text != "" &&
        _adicaoController.text != "") {
      _devolutionWidgetBloc.buttonCartStatusIn.add(true);
    }

    Modular.to.pop();
  }

  _addOlho(String olho) {
    if (olho == "Olho direito") {
      _olhoController.text = "D";
    } else {
      _olhoController.text = "E";
    }
  }

  _onSubmitDialog() {
    Modular.to.popAndPushNamed(
      '/devolution/effectuation',
    );
  }

  _onAddLens(int total) {
    int current = int.parse(_lensController.text);
    if (current < total) {
      _lensController.text = '${int.parse(_lensController.text) + 1}';
    }
  }

  _onRemoveLens() {
    if (int.parse(_lensController.text) > 1) {
      _lensController.text = '${int.parse(_lensController.text) - 1}';
    }
  }

  _onSubmit(String group, serie, nomeProduto) async {
    int quantidade = int.parse(_lensController.text);

    Map<String, dynamic> errors = {};

    Map<String, dynamic> productParams = {
      'degree': {'text': this._degreeController.text, 'name': "Grau"},
      'axis': {'text': this._axisController.text, 'name': "Eixo"},
      'cor': {'text': this._corController.text, 'name': "Cor"},
      'adicao': {'text': this._adicaoController.text, 'name': "Adicao"},
      'cylinder': {'text': this._cylinderController.text, 'name': "Cilindro"}
    };

    this.hasParams.forEach((key, value) {
      if (value) {
        if (productParams[key]['text'] == "") {
          errors[productParams[key]['name']] = ["Não pode estar em branco"];
        }
      }
    });

    if (errors.keys.length > 0) {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, errors);
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
      return;
    }

    Map<String, dynamic> product = {
      "eixo": _axisController.text,
      "cor": _corController.text,
      "produto": nomeProduto,
      "esferico": _degreeController.text,
      "cilindrico": _cylinderController.text,
      "adicao": _adicaoController.text,
      "paciente": _nameController.text,
      "numero": _numberController.text,
      "dt_nas_pac": _birthdayController.text,
      "num_de_serie": serie,
      "quant": quantidade,
      "olho": _olhoController.text
    };

    Map<String, dynamic> params = {
      "group": group,
      "devolution": product,
      "quantidade": quantidade
    };

    Devolution devol = await _devolutionWidgetBloc.nextStepDevolution(params);

    if (!devol.status) {
      _devolutionWidgetBloc.resetPreDevolucao();
      Dialogs.success(
        context,
        onTap: _onSubmitDialog,
      );
    } else {
      _devolutionWidgetBloc.currentDevolutionSink.add(devol);
    }
  }

  List<Map<String, dynamic>> generateProductParams(Parametros parametro) {
    List<Map<String, dynamic>> lists = [
      {
        'labelText': 'Escolha o Grau',
        'key': 'degree',
        'items': parametro.parametro.grausEsferico,
        'controller': _degreeController
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'key': 'cylinder',
        'controller': _cylinderController,
        'items': parametro.parametro.grausCilindrico,
      },
      {
        'labelText': 'Escolha o Eixo',
        'key': 'axis',
        'controller': _axisController,
        'items': parametro.parametro.grausEixo,
      },
      {
        'labelText': 'Escolha a Adicao',
        'key': 'adicao',
        'controller': _adicaoController,
        'items': parametro.parametro.grausAdicao,
      },
      {
        'labelText': 'Escolha a Cor',
        'key': 'cor',
        'controller': _corController,
        'items': parametro.parametro.cor,
      }
    ].where((element) => (element['items'] as List).length > 1).toList();
    lists.forEach((element) {
      this.hasParams[element['key']] = true;
    });
    return lists;
  }

  _onShowOptions(Map<dynamic, dynamic> data, {String key, String param}) {
    print(data);
    Modals.params(
      context,
      items: data,
      onTap: (data, current) =>
          _onChangeParams(data, key: key, current: current, param: param),
      title: data['labelText'],
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _olhoController = TextEditingController(text: "D");
    _lensController = TextEditingController(
      text: '1',
    );
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );
    _degreeController = TextEditingController();
    _axisController = TextEditingController();
    _corController = TextEditingController();
    _cylinderController = TextEditingController();
    _adicaoController = TextEditingController();

    this.hasParams = {
      'degree': false,
      'cylinder': false,
      'axis': false,
      'cor': false,
      'adicao': false
    };

    _devolutionWidgetBloc.currentDevolutionStream.listen((event) {
      if (!event.isLoading) {
        _devolutionWidgetBloc
            .fetchParametros(event.devolution.product["group"]);
      }
    });
    // _devolutionWidgetBloc.fetchParametros(currentProduct.product.group);

    _pacientInfo = [
      {
        'labelText': 'Nome do paciente',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Número do Cliente',
        'icon': MaterialCommunityIcons.numeric,
        'controller': _numberController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'controller': _birthdayController,
      },
    ];
    _productParams = [
      {
        'labelText': 'Escolha o Grau',
        'items': [0.5, 1.0, 1.5],
        'key': 'esferico',
        'controller': _degreeController,
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'items': [0.5, 1.0, 1.5],
        'key': 'cilindrico',
        'controller': _cylinderController,
      },
      {
        'labelText': 'Escolha o Eixo',
        'items': [0.9, 0.7],
        'key': 'eixo',
        'controller': _axisController
      },
      {
        'labelText': 'Escolha a Cor',
        'items': ['Preto', 'Vermelho'],
        'key': 'cor',
        'controller': _corController
      },
      {
        'labelText': 'Escolha a Adição',
        'items': [1, 2, 3],
        'key': 'adicao',
        'controller': _adicaoController
      }
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Devolução'),
          centerTitle: false,
        ),
        body: StreamBuilder(
            stream: _devolutionWidgetBloc.currentDevolutionStream,
            builder: (context, productSnapshot) {
              if (!productSnapshot.hasData || productSnapshot.data.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: ListTileMoreCustomizable(
                        contentPadding: const EdgeInsets.all(5),
                        leading: CachedNetworkImage(
                          imageUrl: productSnapshot
                              .data.devolution.product["imageUrl"],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                            "${productSnapshot.data.devolution.product["title"]}"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "${productSnapshot.data.devolution.quantidade} Caixas"),
                            SizedBox(width: 20),
                            Text(
                                "NF ${productSnapshot.data.devolution.product["nf"]}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 15))
                          ],
                        )),
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                  ),
                  Text(
                    'Informações do Paciente',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Separe o pedido por paciente, assim você terá mais controle de reposição e acumulará Pontos que se tornam Crédito Financeiro!',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _pacientInfo.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return TextFieldWidget(
                        labelText: _pacientInfo[index]['labelText'],
                        prefixIcon: Icon(
                          _pacientInfo[index]['icon'],
                          color: Color(0xffA1A1A1),
                        ),
                        controller: _pacientInfo[index]['controller'],
                      );
                    },
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Quantidade de caixas',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextFieldWidget(
                          width: 120,
                          controller: _lensController,
                          readOnly: true,
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
                              onPressed: () {
                                _onAddLens(
                                    productSnapshot.data.devolution.quantidade);
                              })),
                    ],
                  ),
                  StreamBuilder(
                      stream: _devolutionWidgetBloc.parametroListStream,
                      builder: (context, paramsSnapshot) {
                        if (!paramsSnapshot.hasData ||
                            paramsSnapshot.data.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!paramsSnapshot.data.isValid) {
                          return Center(child: Text("Carregando parametros"));
                        }

                        final _productParamsGenerated =
                            generateProductParams(paramsSnapshot.data);

                        return Column(
                          children: [
                            DropdownWidget(
                              labelText: 'Escolha o olho',
                              items: [
                                'Olho direito',
                                'Olho esquerdo',
                              ],
                              onChanged: (value) => _addOlho(value),
                              currentValue: 'Olho direito',
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              'Parâmetros',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Defina os parâmetros do produto',
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _productParamsGenerated.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10,
                              ),
                              itemBuilder: (context, index) {
                                return TextFieldWidget(
                                  readOnly: true,
                                  labelText: _productParamsGenerated[index]
                                      ['labelText'],
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xffa1a1a1),
                                  ),
                                  controller: _productParamsGenerated[index]
                                      ['controller'],
                                  onTap: () => _onShowOptions(
                                      _productParamsGenerated[index],
                                      key: 'esquerdo',
                                      param: _productParamsGenerated[index]
                                          ['key']),
                                );
                                // return TextFieldWidget(
                                //   readOnly: true,
                                //   suffixIcon: Icon(
                                //     Icons.keyboard_arrow_down,
                                //     color: Color(0xffa1a1a1),
                                //   ),
                                //   controller: TextEditingController(),
                                //   labelText: _productParams[index]
                                //       ['labelText'],
                                //   onTap: (value) => _onChangeParams({
                                //     _productParams[index]['key']: value,
                                //   }),
                                // );

                                // return DropdownWidget(
                                //   items: _productParams[index]['items'],
                                //   labelText: _productParams[index]['labelText'],
                                //   prefixIcon: SizedBox(),
                                //   currentValue: snapshot
                                //       .data[_productParams[index]['key']],
                                //   onChanged: (value) => _onChangeParams({
                                //     _productParams[index]['key']: value,
                                //   }),
                                //);
                              },
                            ),
                          ],
                        );
                      }),

                  SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Text(
                  //       'Quantidade disponivel',
                  //       style: Theme.of(context).textTheme.subtitle1,
                  //     ),
                  //     Text("${snapshot.data.devolution.quantidade}"),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  StreamBuilder<bool>(
                    stream: _devolutionWidgetBloc.buttonCartStatusOut,
                    builder: (context, snapshot) {
                      return Opacity(
                        opacity: 1,
                        child: RaisedButton.icon(
                          onPressed: () {
                            _onSubmit(
                                productSnapshot
                                    .data.devolution.product["group"],
                                productSnapshot
                                    .data.devolution.product["num_serie"],
                                productSnapshot
                                    .data.devolution.product["title"]);
                          },
                          elevation: 0,
                          disabledColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).primaryColor,
                          icon: Image.asset(
                            'assets/icons/cart.png',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Confirmar Solicitação',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }));
  }
}
