import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsScreen extends StatelessWidget {
  ProductBloc _productBloc = Modular.get<ProductBloc>();

  onChangeProduct(ProductModel product) {
    Modular.to.pushNamed(
      '/products/${product.id}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<ProductModel>>(
        stream: _productBloc.indexOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<ProductModel> _products = snapshot.data;
          return GridView.builder(
            itemCount: _products.length,
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return ProductWidget(
                value: _products[index].value,
                title: _products[index].title,
                tests: _products[index].tests,
                imageUrl: _products[index].imageUrl,
                onTap: () => onChangeProduct(
                  _products[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
