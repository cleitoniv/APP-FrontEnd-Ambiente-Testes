import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProductsScreen extends StatelessWidget {
  _handleProduct() {
    Modular.to.pushNamed(
      '/products/1',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ProductWidget(
            value: 76888,
            title: 'Biosoft',
            tests: 2,
            onTap: _handleProduct,
          );
        },
      ),
    );
  }
}
