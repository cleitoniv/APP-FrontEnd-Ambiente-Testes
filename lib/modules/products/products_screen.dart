import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    if(_authBloc.getAuthCurrentUser != null) {
      await _productBloc.favorites(_authBloc.getAuthCurrentUser);
    } else {
      _currentUserSS = _authBloc.clienteDataStream.listen((event) {
        if(event != null && event.data != null) {
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
    if(_currentUserSS != null) {
      _currentUserSS.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(context);
    // print("OLAs");
    return SafeArea(
      child: StreamBuilder(
        stream: _productBloc.favoriteProductListStream,
        builder: (context, favoriteSnapshot) {
          return StreamBuilder(
            stream: _productBloc.productListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<ProductModel> _products = snapshot.data.list;

              _products = _products.map((e) {
                if(favoriteSnapshot.data.any((e1) => e1['group'] == e.group)) {
                  e.factor = 100;
                }

                return e;
              }).toList();

              _products.sort((a, b) => a.factor.compareTo(b.factor));
              _products = _products.reversed.toList();

              return !_isLoadingProduct
                  ? GridView.builder(
                itemCount: _products.length,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.7,
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

//                      bool blocked =
//                      await _authBloc.checkBlockedUser(widget.context);
//
//                      if (!blocked) {
//                        onChangeProduct(_products[index], context);
//                      }
                      onChangeProduct(_products[index], context);
                      setState(() {
                        _isLoadingProduct = false;
                      });
                    },
                  );
                },
              )
                  : Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
