import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
          );
        },
      ),
    );
  }
}
