// import 'dart:convert';
// import 'dart:developer';

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_products_screen.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../repositories/credits_repository.dart';
// import 'package:rxdart/subjects.dart';

class ProductScreen extends StatefulWidget {
  final int id;
  final ProductModel product;

  ProductScreen({this.id, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();
  RequestsBloc _requestBloc = Modular.get<RequestsBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  AuthEvent currentUser;
  HomeWidgetBloc _homeBloc = Modular.get<HomeWidgetBloc>();

  bool _lock = false;

  _onShowInfo(bool value) {
    _productWidgetBloc.showInfoIn.add(!value);
  }

  Function(int) onNavigate;

  _showDialogType(String type, ProductModel product) async {
    print(type);
    if (type == "T") {
      Modular.to.pop();
    } else if (type == 'CF') {
      _homeBloc.currentCreditTypeIn.add('Financeiro');
      _productBloc.fetchOffers();
      Modular.to.pushNamed('/home/1');
    } else {
      _productBloc.offersRedirectedSink.add(null);
      _productBloc.productRedirectedSink.add(null);
  
    Helper.whenDifferentOperation(
        '06', () {
          _homeWidgetBloc.currentCreditTypeIn.add("Produto");
              Navigator.push(
                context,
              MaterialPageRoute(
              builder: (BuildContext context) => CreditsProductScreen(product: product),
            ),
          );
        },
        context,
        _requestBloc
            .cartItems,
        _requestBloc,
        _cartWidgetBloc);
    }
  }

  _onCancelPurchase() {
    Modular.to.pop();
  }

  _showDialog(String title, String content, String type, ProductModel product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
            content: Text(content),
            actions: [
              ElevatedButton(
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Modular.to.pop();
                  }),
              SizedBox(height: 10),
              ElevatedButton(
                  child: Text(
                    "Compre crédito",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _showDialogType(type, product);
                  })
            ]);
      },
    );
  }

  _onConfirmPurchase(ProductModel product, String type, int value) {
    if (type == 'C') {
      if (value <= 0 || product.valueProduto == 0) {
        _showDialog('Atenção',
            'Adquira Crédito de Produto para comprar esse item!', type, product);

        return;
      }
    } else if (type == 'CF') {
      if (value <= 0 || product.valueFinan == 0) {
        if (value <= 0) {
          _showDialog('Atenção',
              'Adquira Crédito Financeiro para comprar esse item!', type, product);

          return;
        } else {
          _showDialog('Atenção',
              'Aguarde o processamento do valor deste produto.', type, product);

          return;
        }
      }
    } else if (type == 'T') {
      if (value <= 0) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                  "Atenção",
                  style: Theme.of(context).textTheme.headline5,
                ),
                content:
                    Text("Adquira saldo de teste para conseguir solicitar."),
                actions: [
                  ElevatedButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Modular.to.pop();
                      }),
                ]);
          },
        );

        return;
      }
    }

    Modular.to.pushNamed(
      '/products/${product.id}/requestDetails',
      arguments: type,
    );
  }

  _favoriteProduct() async {
    setState(() {
      _lock = true;
    });

    bool success = await _productBloc.favorite(widget.product.group);

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code

      setState(() {
        if (success) {
          Modular.to.pushReplacementNamed('/products/${widget.product.id}',
              arguments: widget.product);
        }
      });
    });
  }

  _handleSingleOrder(ProductModel product) {
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
        _onConfirmPurchase(product, 'A', 999);
      },
    );
  }

  _getFavorites() async {
    await _productBloc.favorites(_authBloc.getAuthCurrentUser);
  }

  _likeButton() {
    return StreamBuilder(
        stream: _productBloc.favoriteProductListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          if (!snapshot.data.any((e) => e['group'] == widget.product.group)) {
            return CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.favorite_border,
                size: 30,
              ),
            );
          }
          return CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffFD6565),
            child: Image.asset(
              'assets/icons/heart_outline.png',
              width: 30,
              height: 30,
            ),
          );
        });
  }

  @override
  void initState() {
    this.currentUser = _authBloc.getAuthCurrentUser;
    final product =
        Product(product: widget.product, isLoading: false, isEmpty: false);
    _productBloc.productSink.add(product);
    _productBloc.setCurrentProduct(product);
    _productWidgetBloc.showInfoIn.add(false);
    _getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_lock) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Produto'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: _productBloc.productStream,
        builder: (context, productSnapshot) {
          if (!productSnapshot.hasData || productSnapshot.data.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  title: AutoSizeText(
                    productSnapshot.data.product.title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  trailing: Column(
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: AutoSizeText(
                          'Valor avulso',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                                color: Colors.black38,
                              ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'R\$ ${Helper.intToMoney(productSnapshot.data.product.value)}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 18,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
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
                        ),
                      ),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/no_image_product.jpeg'),
                        imageUrl: productSnapshot.data.product.imageUrl,
                      ),
                    ),
                    Positioned(
                      width: 67,
                      height: 32,
                      left: 20,
                      top: 15,
                      child: StreamBuilder(
                        stream: _productWidgetBloc.showInfoOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                primary: snapshot.data
                                    ? Theme.of(context).accentColor
                                    : Color(0xffA5A5A5),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            onPressed: () => _onShowInfo(
                              snapshot.data,
                            ),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '+INFO',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        _favoriteProduct();
                      },
                      child: _likeButton()),
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        {
                          'title': 'Financeiro',
                          'subtitle':
                              'R\$ ${Helper.intToMoney(this.currentUser.data.money)}',
                          'color': Theme.of(context).primaryColor,
                          'widget': Icon(
                            Icons.attach_money,
                            color: Colors.white,
                            size: 20,
                          ),
                        },
                        {
                          'title': 'Produto',
                          'subtitle':
                              '${productSnapshot.data.product.boxes} caixas',
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
                          'subtitle':
                              "${productSnapshot.data.product.tests} testes",
                          'color': Colors.black12,
                          'widget': Icon(
                            Icons.remove_red_eye,
                            color: Colors.black54,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            subtitle: Text(
                              item['subtitle'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
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
                StreamBuilder(
                  stream: _productWidgetBloc.showInfoOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    inspect(productSnapshot.data);
                    return Container(
                      height: snapshot.data ? null : 0,
                      width: snapshot.data ? null : 0,
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: <Widget>[
                          Text(
                            'Especificações',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          Table(
                              children: [
                            
                            {
                              'title': 'Material',
                              'value': productSnapshot.data.product.material ?? '-',
                            },
                            {
                              'title': 'DK/t',
                              'value': productSnapshot.data.product.dkT ?? '-',
                            },
                            {
                              'title': 'Visint',
                              'value': productSnapshot.data.product.visint ?? '-',
                            },
                            {
                              'title': 'Espessura',
                              'value': productSnapshot.data.product.espessura != null ? '${productSnapshot.data.product.espessura}' : '-' ,
                            },
                            {
                              'title': 'Hidratação',
                              'value':
                                  productSnapshot.data.product.hidratacao != null ? '${productSnapshot.data.product.hidratacao}' : '-' ,
                            },
                            {
                              'title': 'Assepsia',
                              'value': productSnapshot.data.product.assepsia ?? '-',
                            },
                            {
                              'title': 'Descarte',
                              'value': productSnapshot.data.product.descarte ?? '-',
                            },
                            
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    "${e['title']}",
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
                          ).toList()),
                          SizedBox(height: 30),
                          Text(
                            'Parâmetros',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Table(
                              children: [
                            {
                              'title': 'Diâmetro (mm)',
                              'value': productSnapshot.data.product.diametro ?? '',
                            },
                            {
                              'title': 'Curva base (mm)',
                              'value': productSnapshot.data.product.curvaBase ?? '',
                            },
                            {
                              'title': 'Grau',
                              'value': productSnapshot.data.product.grau ?? '-',
                            },
                            {
                              'title': 'Cilindrico',
                              'value': productSnapshot.data.product.cilindrico ?? '-',
                            },
                            {
                              'title': 'eixo',
                              'value': productSnapshot.data.product.grausEixo ?? '-'
                            },
                            {
                              'title': 'Adicao',
                              'value': productSnapshot.data.product.adicao ?? '-',
                            },
                            {
                              'title': 'Cor',
                              'value': productSnapshot.data.product.cor ?? '-'
                            },
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    "${e['title']}",
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
                          ).toList())
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                StreamBuilder<bool>(
                  stream: _productWidgetBloc.showInfoOut,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data) {
                      return ElevatedButton(
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
                      children: <Widget>[
                        Text(
                          'O que deseja solicitar?',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 18,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            {
                              'title':
                                  'Pedido Avulso R\$ ${Helper.intToMoney(productSnapshot.data.product.value)}',
                              'color': Color(0xff707070),
                              'onTap': () {
                                Helper.whenDifferentOperation('01', () {
                                  _handleSingleOrder(
                                    productSnapshot.data.product,
                                  );
                                }, context, _requestBloc.cartItems,
                                    _requestBloc, _cartWidgetBloc);
                              },
                            },
                            {
                              'title':
                                  'Crédito de Produto R\$ ${Helper.intToMoney(productSnapshot.data.product.valueProduto)}',
                              'color': Theme.of(context).accentColor,
                              'onTap': () => Helper.whenDifferentOperation('07',
                                      () {
                                    _onConfirmPurchase(
                                        productSnapshot.data.product,
                                        'C',
                                        productSnapshot.data.product.boxes);
                                  }, context, _requestBloc.cartItems,
                                      _requestBloc, _cartWidgetBloc)
                            },
                            {
                              'title':
                                  'Crédito Financeiro R\$ ${Helper.intToMoney(productSnapshot.data.product.valueFinan)}',
                              'color': Theme.of(context).primaryColor,
                              'onTap': () => Helper.whenDifferentOperation('13',
                                      () {
                                    _onConfirmPurchase(
                                        productSnapshot.data.product,
                                        'CF',
                                        this.currentUser.data.money);
                                  }, context, _requestBloc.cartItems,
                                      _requestBloc, _cartWidgetBloc)
                            },
                            {
                              'title': 'Solicitar Teste',
                              'color': Color(0xff707070),
                              'onTap': () => Helper.whenDifferentOperation('03',
                                      () {
                                    _onConfirmPurchase(
                                        productSnapshot.data.product,
                                        'T',
                                        productSnapshot.data.product.tests);
                                  }, context, _requestBloc.cartItems,
                                      _requestBloc, _cartWidgetBloc)
                            },
                          ]
                          .where((element) => element['title'] != 'Solicitar Teste' || productSnapshot.data.product.hasTest)
                          .map(
                            (item) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: item['color'], elevation: 0),
                                  onPressed: item['onTap'],
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "${item['title']}",
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        )
                      ],
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
