import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;
  final ProductModel product;

  ProductDetailScreen({this.id, this.product});

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

  _onAddToCart(Map data) async {
    Map<String, dynamic> _data = {
      'quantity': int.parse(_lensController.text),
      'product': data['product'],
      'type': "C",
      'operation': "06"
    };

    int _total = _cartWidgetBloc.currentCartTotalItems;
    _cartWidgetBloc.cartTotalItemsSink.add(_total + 1);
    _requestsBloc.addProductToCart(_data);
    Modular.to.pushNamed("/credito_financeiro/cart");
  }

  _onAddLens() {
    _lensController.text = '${int.parse(_lensController.text) + 1}';
  }

  _onRemoveLens() {
    if (int.parse(_lensController.text) > 1) {
      _lensController.text = '${int.parse(_lensController.text) - 1}';
    }
  }

  @override
  void initState() {
    this.currentUser = _authBloc.getAuthCurrentUser;
    _lensController = TextEditingController(
      text: '1',
    );
    _productBloc.productSink.add(
        Product(product: widget.product, isLoading: false, isEmpty: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  title: Text(
                    productSnapshot.data.product.title,
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
                        'R\$ ${Helper.intToMoney(productSnapshot.data.product.value)}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
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
                                padding: const EdgeInsets.all(0),
                                backgroundColor: snapshot.data
                                    ? Theme.of(context).accentColor
                                    : Color(0xffA5A5A5),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: Text(
                              '+INFO',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
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
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 18,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          Text(
                            "${productSnapshot.data.product.descricao}",
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Color(0xffa1a1a1),
                                    ),
                          ),
                          SizedBox(height: 20),
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
                              'value': productSnapshot.data.product.material,
                            },
                            {
                              'title': 'DK/t',
                              'value': productSnapshot.data.product.dkT,
                            },
                            {
                              'title': 'Visint',
                              'value': productSnapshot.data.product.visint
                                  ? 'Sim'
                                  : 'Não',
                            },
                            {
                              'title': 'Espessura',
                              'value':
                                  '${productSnapshot.data.product.espessura}mm',
                            },
                            {
                              'title': 'Hidratação',
                              'value':
                                  '${productSnapshot.data.product.hidratacao}%',
                            },
                            {
                              'title': 'Assepsia',
                              'value': productSnapshot.data.product.assepsia,
                            },
                            {
                              'title': 'Descarte',
                              'value': productSnapshot.data.product.descarte,
                            },
                            {
                              'title': 'Desenho',
                              'value': productSnapshot.data.product.desenho,
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
                              'value': productSnapshot.data.product.diametro,
                            },
                            {
                              'title': 'Curva base (mm)',
                              'value': productSnapshot.data.product.curvaBase,
                            },
                            {
                              'title': 'Esférico (D)',
                              'value': productSnapshot.data.product.esferico,
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
                        SizedBox(height: 20),
                        Column(
                          children: [
                            {
                              'title': 'Adicionar ao Carrinho',
                              'color': Theme.of(context).accentColor,
                              'onTap': () => _onAddToCart(
                                  {"product": productSnapshot.data.product}),
                            },
                          ].map(
                            (item) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: item['color'],
                                      elevation: 0),
                                  onPressed: item['onTap'],
                                  child: Text(
                                    item['title'],
                                    style: Theme.of(context).textTheme.button,
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
