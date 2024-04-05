import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
// import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsScreen extends StatefulWidget {
  final BuildContext context;

  const ProductsScreen({Key key, this.context}) : super(key: key);
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc _productBloc = Modular.get<ProductBloc>();

  bool _isLoadingProduct;

  AuthBloc _authBloc = Modular.get<AuthBloc>();

  StreamSubscription _currentUserSS;

  onChangeProduct(ProductModel product, BuildContext context) async {
    await Modular.to.pushNamed('/products/${product.id}', arguments: product);
  }

  _getFavorites() async {
    if (_authBloc.getAuthCurrentUser != null) {
      await _productBloc.favorites(_authBloc.getAuthCurrentUser);
    } else {
      _currentUserSS = _authBloc.clienteDataStream.listen((event) {
        if (event != null && event.data != null) {
          _productBloc.favorites(event);
        }
      });
    }
  }

  @override
  void initState() {
    _isLoadingProduct = false;
    super.initState();
    _getFavorites();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_currentUserSS != null) {
      _currentUserSS.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _productBloc.favoriteProductListStream,
        builder: (context, favoriteSnapshot) {
          return StreamBuilder(
            stream: _productBloc.productListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("Carregando aguarde...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 16))
                          ])
                    ]);
              }

              List<ProductModel> _products = snapshot.data.list;
              if (favoriteSnapshot.data != null) {
                _products = _products.map((e) {
                  if (favoriteSnapshot.data
                      .any((e1) => e1['group'] == e.group)) {
                    e.factor = 100;
                  }

                  return e;
                }).toList();
              }

              return !_isLoadingProduct
                  ? Stack(
                    children: [GridView.builder(
                        itemCount: _products.length,
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.9,
                        ),
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            value: _products[index].value,
                            title: _products[index].title,
                            tests: _products[index].tests,
                            imageUrl: _products[index].imageUrl,
                            credits: _products[index].boxes,
                            onTap: () async {
                              setState(() {
                                _isLoadingProduct = true;
                              });
                              onChangeProduct(_products[index], context);
                              setState(() {
                                _isLoadingProduct = false;
                              });
                              _authBloc.fetchCurrentUser();
                            },
                          );
                        },
                      ), 
                      Container(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          iconSize: 50,
                          onPressed: () {
                            launch('https://api.whatsapp.com/send?phone=5527997436711');
                        }, icon: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/WhatsApp_Logo.png',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                       ),
                     ),
                   ]
                  )
                  : Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
