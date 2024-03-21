import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

import '../../models/offer.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final ProductModel product;
  final List<OfferModel> offers;

  ProductDetailScreen({this.id, this.product, this.offers});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  ProductWidgetBloc _productWidgetBloc = Modular.get<ProductWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  AuthEvent currentUser;
  TextEditingController _lensController;

  _onShowInfo(bool value) {
    _productWidgetBloc.showInfoIn.add(!value);
  }

  _onAddToCart(Map<dynamic, dynamic> data, valor) async {
    print('mapa manipulado:');
    // print(_manipulatedMap(data['product'], valor));
    ProductModel productModel2 = _manipulatedMap(data['product'], valor);
    print(productModel2);
    var _data = {
      'quantity': int.parse(_lensController.text == '' ? '1' : _lensController.text),
      'product': productModel2 ,
      'type': "C",
      'operation': "07",
      'value': valor
    };
    print(_data);
    int _total = _cartWidgetBloc.currentCartTotalItems;
    _cartWidgetBloc.cartTotalItemsSink.add(_total + 1);
    _requestsBloc.addProductToCart(_data);
    Modular.to.pushNamed("/credito_financeiro/cart");
  }

  _manipulatedMap(instance, valor) {
  ProductModel  productModel2  = new ProductModel(); 
  
    productModel2.assepsia = instance.assepsia;
    productModel2.boxes = instance.boxes;
    productModel2.credits = instance.credits;
    productModel2.curvaBase = instance.curvaBase;
    productModel2.descarte = instance.descarte;
    productModel2.descricao = instance.descricao;
    productModel2.desenho = instance.desenho;
    productModel2.diametro = instance.diametro;
    productModel2.dkT = instance.dkT;
    productModel2.duracao = instance.duracao;
    productModel2.enderecoEntrega = instance.enderecoEntrega;
    productModel2.esferico = instance.esferico;
    productModel2.espessura = instance.espessura;
    productModel2.factor = instance.factor;
    productModel2.grausCilindrico = instance.grausCilindrico;
    productModel2.grausEixo = instance.grausEixo;
    productModel2.grausEsferico = instance.grausEsferico;
    productModel2.group = instance.group;
    productModel2.groupTest = instance.groupTest;
    productModel2.hasAcessorio = instance.hasAcessorio;
    productModel2.hasAdicao = instance.hasAdicao;
    productModel2.hasCilindrico = instance.hasCilindrico;
    productModel2.hasCor = instance.hasCor;
    productModel2.hasEixo = instance.hasEixo;
    productModel2.hasEsferico = instance.hasEsferico;
    productModel2.hasTest = instance.hasTest;
    productModel2.hidratacao = instance.hidratacao;
    productModel2.id = instance.id;
    productModel2.imageUrl = instance.imageUrl;
    productModel2.imageUrlTest = instance.imageUrlTest;
    productModel2.material = instance.material;
    productModel2.message = instance.message;
    productModel2.nf = instance.nf;
    productModel2.numSerie = instance.numSerie;
    productModel2.previsaoEntrega = instance.previsaoEntrega;
    productModel2.produto = instance.produto;
    productModel2.produtoTeste = instance.produtoTeste;
    productModel2.quantidade = instance.quantidade;
    productModel2.tests = instance.tests;
    productModel2.title = instance.title;
    productModel2.type = instance.type;
    productModel2.valid = instance.valid;
    productModel2.value = valor;
    productModel2.valueFinan = instance.valueFinan;
    productModel2.valueProduto = valor;
    productModel2.valueTest = instance.valueTest;
    productModel2.visint = instance.visint;
  
   return productModel2;
}

  _onAddLens() {
    print('valor text:');
    print(_lensController.text);
    _lensController.text = '${int.parse(_lensController.text == '' ? '0' : _lensController.text) + 1}';
  }

  _onRemoveLens() {
    if (int.parse(_lensController.text) > 1) {
      _lensController.text = '${int.parse(_lensController.text) - 1}';
    }
  }

  _verifyDiscount(valor, offers) {
    var args = ModalRoute.of(context)?.settings?.arguments as Map;
    if (offers != null) {
     
        List<int> quantidadecx = [];
        List<int> valores = [];
        for (var i = 0; i < offers.length; i++) {
          valores.add(offers[i].price);
        }
        for (var i = 0; i < offers.length; i++) {
          quantidadecx.add(offers[i].quantity);
        }
        print(quantidadecx);
        print(valores);
        if (int.parse(_lensController.text == '' ? '0' : _lensController.text) > quantidadecx[0] && int.parse(_lensController.text == '' ? '0' : _lensController.text) <= quantidadecx[1]) {
          return valores[1];
        } else if (int.parse(_lensController.text == '' ? '0' : _lensController.text) > quantidadecx[1] && int.parse(_lensController.text == '' ? '0' : _lensController.text) <= quantidadecx[2]) {
          return valores[2];
        } else if (int.parse(_lensController.text == '' ? '0' : _lensController.text) > quantidadecx[2] && int.parse(_lensController.text == '' ? '0' : _lensController.text) <= quantidadecx[3]) {
          return valores[3];
        } else if (int.parse(_lensController.text == '' ? '0' : _lensController.text) > quantidadecx[3]) {
          return valores.reduce(min);
        } else {
          return valores.reduce(max);
        }
    } else {
      return args['produto'].value;
    }
  }

  @override
  void initState() {
    this.currentUser = _authBloc.getAuthCurrentUser;
    _lensController = TextEditingController(
      text: '1',
    );
    _lensController?.addListener(() {
      setState(() {
        _lensController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    var args = ModalRoute.of(context)?.settings?.arguments as Map;
    _productBloc.productSink.add(
        Product(product: args['produto'] as ProductModel, isLoading: false, isEmpty: false));
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
            // inspect(ModalRoute.of(context)?.settings?.arguments);
            // print(ModalRoute.of(context)?.settings?.arguments);
            // print(productSnapshot.data.product);
            // inspect(productSnapshot.data.product);

            return ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  title: Text(
                    productSnapshot.data.product.title,
                    style: Theme.of(context).textTheme.titleMedium.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  trailing: Column(
                    children: <Widget>[
                      Text(
                        'Valor Unidade:',
                        style: Theme.of(context).textTheme.titleMedium.copyWith(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                      ),
                      Text(
                        // 'R\$ ${Helper.intToMoney(productSnapshot.data.product.valueProduto)}',
                        'R\$ ${Helper.intToMoney(_verifyDiscount(args['ofertas'][0].price, args['ofertas']))}',
                        style: Theme.of(context).textTheme.headlineSmall.copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),  
                ),
                Stack(
                  clipBehavior: Clip.none,
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
                            onPressed: () => _onShowInfo(
                              snapshot.data,
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0), primary: snapshot.data
                                    ? Theme.of(context).colorScheme.secondary
                                    : Color(0xffA5A5A5),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: Text(
                              '+INFO',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Positioned(
                    //   bottom: -30,
                    //   right: 20,
                    //   child: CircleAvatar(
                    //     radius: 30,
                    //     backgroundColor: Color(0xffFD6565),
                    //     child: Image.asset(
                    //       'assets/icons/heart_outline.png',
                    //       width: 30,
                    //       height: 30,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 30),
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
                              '${productSnapshot.data.product.tests} un.',
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
                                  .titleMedium
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            subtitle: Text(
                              item['subtitle'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Quantidade de caixas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFieldWidget(
                        width: 120,
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
                            onPressed: _onAddLens)),
                  ],
                ),
                StreamBuilder(
                  stream: _productWidgetBloc.showInfoOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: snapshot.data ? null : 0,
                      width: snapshot.data ? null : 0,
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        children: <Widget>[
                          Text(
                            'Descrição do produto',
                            style:
                                Theme.of(context).textTheme.headlineSmall.copyWith(
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          Text(
                            "${productSnapshot.data.product.descricao}",
                            style:
                                Theme.of(context).textTheme.titleMedium.copyWith(
                                      color: Color(0xffa1a1a1),
                                    ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Especificações',
                            style:
                                Theme.of(context).textTheme.headlineSmall.copyWith(
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          Table(
                              children: [
                            {
                              'title': 'Material',
                              'value': productSnapshot.data.product.material ?? '',
                            },
                            {
                              'title': 'DK/t',
                              'value': productSnapshot.data.product.dkT ?? '',
                            },
                            {
                              'title': 'Visint',
                              'value': productSnapshot.data.product.visint ?? ''
                                  // ? 'Sim'
                                  // : 'Não',
                            },
                            {
                              'title': 'Espessura',
                              'value': productSnapshot.data.product.espessura != null ? '${productSnapshot.data.product.espessura}' + 'mm' : '' ,
                            },
                            {
                              'title': 'Hidratação',
                              'value':
                                  productSnapshot.data.product.hidratacao != null ? '${productSnapshot.data.product.hidratacao}' + '' : '' ,
                            },
                            {
                              'title': 'Assepsia',
                              'value': productSnapshot.data.product.assepsia ?? '',
                            },
                            {
                              'title': 'Descarte',
                              'value': productSnapshot.data.product.descarte ?? '',
                            },
                            {
                              'title': 'Desenho',
                              'value': productSnapshot.data.product.desenho ?? '',
                            },
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    "${e['title']}",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${e['value']}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              );
                            },
                          ).toList()),
                          SizedBox(height: 30),
                          Text(
                            'Parâmetros',
                            style:
                                Theme.of(context).textTheme.headlineSmall.copyWith(
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
                              'title': 'Esférico (D)',
                              'value': productSnapshot.data.product.esferico ?? '',
                            },
                          ].map(
                            (e) {
                              return TableRow(
                                children: [
                                  Text(
                                    e['title'],
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    '${e['value']}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
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
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Column(
                          children: [
                            {
                              'title': 'Adicionar ao Carrinho',
                              'color': Theme.of(context).colorScheme.secondary,
                              'onTap': () =>
                              _onAddToCart(
                                  {"product": productSnapshot.data.product}, _verifyDiscount(args['ofertas'][0].price, args['ofertas'])),
                            },
                          ].map(
                            (item) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: item['color'], elevation: 0),
                                  onPressed: item['onTap'],
                                  child: Text(
                                    item['title'],
                                    style: Theme.of(context).textTheme.labelLarge,
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
