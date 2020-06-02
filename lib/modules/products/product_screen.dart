import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductScreen extends StatefulWidget {
  int id;

  ProductScreen({
    this.id,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();

  _onShowInfo(bool value) {
    _productWidgetBloc.showInfoIn.add(!value);
  }

  _onCancelPurchase() {
    Modular.to.pop();
  }

  _onConfirmPurchase() {
    Modular.to.pushNamed(
      '/products/1/requestDetails',
    );
  }

  _handleSingleOrder() {
    Dialogs.confirm(
      context,
      title: 'Deseja confirmarcompra avulsa?',
      subtitle:
          'O valor da compra avulsa é maior do que a de créditos, tem certeza que deseja comprar avulsamente?',
      confirmText: 'Confirmar Compra',
      cancelText: 'Cancelar Compra',
      onCancel: _onCancelPurchase,
      onConfirm: () {
        Modular.to.pop();
        _onConfirmPurchase();
      },
    );
  }

  @override
  void initState() {
    _productBloc.showIn.add(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Produto'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          StreamBuilder<ProductModel>(
              stream: _productBloc.showOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  title: Text(
                    snapshot.data.title,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Text(
                        'Valor avulso',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                      ),
                      Text(
                        'R\$ ${Helper.intToMoney(snapshot.data.value)}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                );
              }),
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 30),
                height: 208,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      width: 0.5,
                      color: Colors.black26,
                    ),
                    bottom: BorderSide(
                      width: 0.5,
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
                ),
              ),
              Positioned(
                width: 67,
                height: 32,
                left: 20,
                top: 15,
                child: StreamBuilder<bool>(
                  stream: _productWidgetBloc.showInfoOut,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      onPressed: () => _onShowInfo(
                        snapshot.data,
                      ),
                      padding: const EdgeInsets.all(0),
                      color: snapshot.data
                          ? Theme.of(context).accentColor
                          : Color(0xffA5A5A5),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '+INFO',
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontSize: 14,
                            ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: -30,
                right: 20,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffFD6565),
                  child: Image.asset(
                    'assets/icons/heart_outline.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Table(
            children: [
              TableRow(
                children: [
                  {
                    'title': 'Financeiro',
                    'subtitle': 'R\$ ${Helper.intToMoney(200000)}',
                    'color': Theme.of(context).primaryColor,
                    'widget': Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 20,
                    ),
                  },
                  {
                    'title': 'Produto',
                    'subtitle': '0 caixas',
                    'color': Color(0xffEFC75E),
                    'widget': Image.asset(
                      'assets/icons/open_box.png',
                      width: 15,
                      height: 15,
                      color: Colors.white,
                    ),
                  },
                  {
                    'title': 'Testes',
                    'subtitle': '30 un.',
                    'color': Color(0xffA5A5A5),
                    'widget': Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 15,
                    ),
                  }
                ].map(
                  (item) {
                    return ListTileMoreCustomizable(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: -5,
                      leading: CircleAvatar(
                        backgroundColor: item['color'],
                        radius: 12,
                        child: item['widget'],
                      ),
                      title: Text(
                        item['title'],
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      subtitle: Text(
                        item['subtitle'],
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          StreamBuilder<bool>(
            stream: _productWidgetBloc.showInfoOut,
            builder: (context, snapshot) {
              return Container(
                height: snapshot.data ? null : 0,
                width: snapshot.data ? null : 0,
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      'Descrição do produto',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 18,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    StreamBuilder<ProductModel>(
                        stream: _productBloc.showOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              heightFactor: 3,
                              child: CircularProgressIndicator(),
                            );
                          }

                          return Text(
                            snapshot.data.details.description,
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Color(0xffa1a1a1),
                                    ),
                          );
                        }),
                    SizedBox(height: 20),
                    Text(
                      'Especificações',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 18,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    StreamBuilder<ProductModel>(
                      stream: _productBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            heightFactor: 3,
                            child: CircularProgressIndicator(),
                          );
                        }

                        ProductModel _product = snapshot.data;

                        return Table(
                          children: [
                            {
                              'title': 'Material',
                              'value': _product.details.material,
                            },
                            {
                              'title': 'DK/t',
                              'value': _product.details.dkt,
                            },
                            {
                              'title': 'Vistint',
                              'value': _product.details.vistint ? 'Sim' : 'Não',
                            },
                            {
                              'title': 'Espessura',
                              'value': '${_product.details.thickness / 100}mm',
                            },
                            {
                              'title': 'Hidratação',
                              'value': '${_product.details.hydration}%',
                            },
                            {
                              'title': 'Assepsia',
                              'value': _product.details.assepsis,
                            },
                            {
                              'title': 'Descarte',
                              'value': _product.details.discard,
                            },
                            {
                              'title': 'Desenho',
                              'value': _product.details.design,
                            },
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    e['title'],
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    '${e['value']}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Parâmetros',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 18,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<ProductModel>(
                      stream: _productBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            heightFactor: 3,
                            child: CircularProgressIndicator(),
                          );
                        }

                        ProductModel _product = snapshot.data;

                        return Table(
                          children: [
                            {
                              'title': 'Diâmetro (mm)',
                              'value': _product.details.diameter / 100,
                            },
                            {
                              'title': 'Curva base (mm)',
                              'value': _product.details.baseCurve / 100,
                            },
                            {
                              'title': 'Esférico (D)',
                              'value':
                                  '${_product.details.spherical[0]} a ${_product.details.spherical[1]}',
                            },
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    e['title'],
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    '${e['value']}',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            'Como deseja comprar?',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          StreamBuilder<bool>(
              stream: _productWidgetBloc.showInfoOut,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return RaisedButton(
                    onPressed: () => _onShowInfo(
                      snapshot.data,
                    ),
                    child: Text(
                      'Voltar aos Detalhes',
                      style: Theme.of(context).textTheme.button,
                    ),
                  );
                }

                return Column(
                  children: [
                    {
                      'title': 'Pedido Avulso R\$ ${Helper.intToMoney(15100)}',
                      'color': Color(0xff707070),
                      'onTap': _handleSingleOrder,
                    },
                    {
                      'title':
                          'Crédito de Produto R\$ ${Helper.intToMoney(25000)}',
                      'color': Theme.of(context).primaryColor,
                      'onTap': _onConfirmPurchase,
                    },
                    {
                      'title':
                          'Crédito Financeiro R\$ ${Helper.intToMoney(25000)}',
                      'color': Theme.of(context).accentColor,
                      'onTap': _onConfirmPurchase,
                    }
                  ].map(
                    (item) {
                      return Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: RaisedButton(
                          onPressed: item['onTap'],
                          color: item['color'],
                          elevation: 0,
                          child: Text(
                            item['title'],
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                );
              }),
        ],
      ),
    );
  }
}
