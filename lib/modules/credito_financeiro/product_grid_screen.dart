import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsGridScreen extends StatelessWidget {
  final ProductBloc _productBloc = Modular.get<ProductBloc>();

  onChangeProduct(ProductModel product) {
    Modular.to.pushNamed(
      '/credito_financeiro/produto/${product.id}',
      arguments: product,
    );
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
          return GridView.builder(
            itemCount: _products.length,
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              print(_products);
              inspect(_products);
              return ProductWidget(
                value: _products[index].value,
                title: _products[index].title,
                tests: _products[index].tests,
                credits: _products[index].boxes,
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
