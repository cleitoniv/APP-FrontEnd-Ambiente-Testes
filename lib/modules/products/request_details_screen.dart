import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/helper/modals.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestDetailsScreen extends StatefulWidget {
  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();
  List<Map> _productParams;
  List<Map> _fieldData;
  TextEditingController _nameController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;

  _onAddToCart() {}
  _onBackToPurchase() {}
  _onPurchase() {}

  List<Map> _renderButtons() {
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
        'onTap': _onAddToCart,
        'text': 'Adicionar ao Carrinho',
      }
    ];
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

  _onSelectOption(
    Map<dynamic, dynamic> data,
    double current, {
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
      print(_first['Graus diferentes em cada olho']['esquerdo']);
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
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );
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

    _productParams = [
      {
        'labelText': 'Escolha o Grau',
        'items': [
          -0.50,
          -0.75,
          -1.00,
          -1.25,
          -1.50,
          0.50,
          0.75,
          1.00,
          1.25,
          1.50,
        ],
        'key': 'degree',
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'items': [1.0, 9.0, 8.0],
        'key': 'cylinder',
      },
      {
        'labelText': 'Escolha o Eixo',
        'items': [1.0, 0.9, 0.7],
        'key': 'axis',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    imageUrl:
                        'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
                    width: 120,
                    height: 100,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'R\$ ${Helper.intToMoney(20000)}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
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
                  Text(
                    'Bioview Asferica Cx 6',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
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
              ),
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
          Text(
            'Parâmetros',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Defina os parâmetros do produto',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          StreamBuilder<Map<dynamic, dynamic>>(
            stream: _productWidgetBloc.pacientInfoOut,
            builder: (context, snapshot) {
              return DropdownWidget(
                labelText: 'Escolha os olhos',
                items: [
                  'Olho direito',
                  'Olho esquerdo',
                  'Mesmo grau em ambos',
                  'Graus diferentes em cada olho',
                ],
                onChanged: (value) => _onAddParam({
                  'current': value,
                }),
                currentValue: snapshot.data['current'],
              );
            },
          ),
          SizedBox(height: 20),
          StreamBuilder<Map<dynamic, dynamic>>(
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
                    Text(
                      snapshot.data['current'],
                      style: Theme.of(context).textTheme.headline5,
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
                        return TextFieldWidget(
                          readOnly: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xffa1a1a1),
                          ),
                          controller: TextEditingController()
                            ..text = snapshot.data[snapshot.data['current']]
                                    [_productParams[index]['key']]
                                .toString(),
                          labelText: _productParams[index]['labelText'],
                          onTap: () => _onShowOptions(
                            _productParams[index],
                          ),
                        );
                        // return DropdownWidget(
                        //   items: _productParams[index]['items'],
                        //   labelText: _productParams[index]['labelText'],
                        //   prefixIcon: SizedBox(),
                        //   currentValue: snapshot.data[snapshot.data['current']]
                        //       [_productParams[index]['key']],
                        //   onChanged: (value) {
                        //     _onAddParam({
                        //       snapshot.data['current']: {
                        //         ...snapshot.data[snapshot.data['current']],
                        //         _productParams[index]['key']: value,
                        //       }
                        //     });
                        //   },
                        // );
                      },
                    ),
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Olho direito',
                          style: Theme.of(context).textTheme.headline5,
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
                            return TextFieldWidget(
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xffa1a1a1),
                              ),
                              controller: TextEditingController()
                                ..text = snapshot
                                    .data['Graus diferentes em cada olho']
                                        ['direito']
                                        [_productParams[index]['key']]
                                    .toString(),
                              labelText: _productParams[index]['labelText'],
                              onTap: () => _onShowOptions(
                                _productParams[index],
                                key: 'direito',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Olho esquerdo',
                          style: Theme.of(context).textTheme.headline5,
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
                            return TextFieldWidget(
                              readOnly: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xffa1a1a1),
                              ),
                              controller: TextEditingController()
                                ..text = snapshot
                                    .data['Graus diferentes em cada olho']
                                        ['esquerdo']
                                        [_productParams[index]['key']]
                                    .toString(),
                              labelText: _productParams[index]['labelText'],
                              onTap: () => _onShowOptions(
                                _productParams[index],
                                key: 'esquerdo',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 10),
          Column(
            children: _renderButtons().map(
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
                      e['text'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: e['textColor'],
                          ),
                    ),
                  ),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }
}
