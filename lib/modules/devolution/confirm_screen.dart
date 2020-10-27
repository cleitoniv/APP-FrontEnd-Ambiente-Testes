import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
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

  _onChangeParams(Map<String, dynamic> data) async {
    Map<String, dynamic> _first =
        await _devolutionWidgetBloc.productParamsOut.first;

    if (_first == null) {
      _devolutionWidgetBloc.productParamsIn.add(data);
    } else {
      _devolutionWidgetBloc.productParamsIn.add({
        ..._first,
        ...data,
      });
    }

    Map<String, dynamic> _updatedFirst =
        await _devolutionWidgetBloc.productParamsOut.first;

    if (_updatedFirst['degree'] != null &&
        _updatedFirst['cylinder'] != null &&
        _updatedFirst['axis'] != null &&
        _updatedFirst['color'] != null &&
        _updatedFirst['addition'] != null) {
      _devolutionWidgetBloc.buttonCartStatusIn.add(true);
    }
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

  _onSubmit(String group, serie) async {
    Map<String, dynamic> _updatedFirst =
        await _devolutionWidgetBloc.productParamsOut.first;

    int quantidade = int.parse(_lensController.text);

    Map<String, dynamic> product = {
      ..._updatedFirst,
      "paciente": _nameController.text,
      "numero": _numberController.text,
      "dt_nas_pac": _birthdayController.text,
      "num_serie": serie,
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
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'items': [0.5, 1.0, 1.5],
        'key': 'cilindrico',
      },
      {
        'labelText': 'Escolha o Eixo',
        'items': [0.9, 0.7],
        'key': 'eixo',
      },
      {
        'labelText': 'Escolha a Cor',
        'items': ['Preto', 'Vermelho'],
        'key': 'cor',
      },
      {
        'labelText': 'Escolha a Adição',
        'items': [1, 2, 3],
        'key': 'adicao',
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
                    itemCount: _productParams.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return StreamBuilder<Map<String, dynamic>>(
                        stream: _devolutionWidgetBloc.productParamsOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return DropdownWidget(
                            items: _productParams[index]['items'],
                            labelText: _productParams[index]['labelText'],
                            prefixIcon: SizedBox(),
                            currentValue:
                                snapshot.data[_productParams[index]['key']],
                            onChanged: (value) => _onChangeParams({
                              _productParams[index]['key']: value,
                            }),
                          );
                        },
                      );
                    },
                  ),
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
                                    .data.devolution.product["num_serie"]);
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
