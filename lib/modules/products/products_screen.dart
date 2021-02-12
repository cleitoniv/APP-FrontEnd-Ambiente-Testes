import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ProductBloc _productBloc = Modular.get<ProductBloc>();

  bool _isLoadingProduct;

  AuthBloc _authBloc = Modular.get<AuthBloc>();

  onChangeProduct(ProductModel product, BuildContext context) async {
    await Modular.to.pushNamed('/products/${product.id}', arguments: product);
  }

  @override
  void initState() {
    _isLoadingProduct = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _productBloc.productListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<ProductModel> _products = snapshot.data.list;
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
                        bool blocked =
                            await _authBloc.checkBlockedUser(context);
                        if (!blocked) {
                          onChangeProduct(_products[index], context);
                        }
                        setState(() {
                          _isLoadingProduct = false;
                        });
                      },
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
