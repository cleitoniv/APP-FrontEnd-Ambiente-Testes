import 'package:central_oftalmica_app_cliente/models/product_model.dart';

class ProductCreditModel {
  int id;
  int total;
  List<ProductModel> products;

  ProductCreditModel({this.id, this.total, this.products});

  ProductCreditModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    if (json['products'] != null) {
      products = new List<ProductModel>();
      json['products'].forEach((v) {
        products.add(new ProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total'] = this.total;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
