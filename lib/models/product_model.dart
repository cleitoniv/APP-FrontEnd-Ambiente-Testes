import 'package:central_oftalmica_app_cliente/models/details_model.dart';

class ProductModel {
  int id;
  String title;
  int value;
  int tests;
  String imageUrl;
  Details details;

  ProductModel({
    this.id,
    this.title,
    this.value,
    this.tests,
    this.imageUrl,
    this.details,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    tests = json['tests'];
    imageUrl = json['imageUrl'];
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['value'] = this.value;
    data['tests'] = this.tests;
    data['imageUrl'] = this.imageUrl;
    if (this.details != null) {
      data['details'] = this.details.toJson();
    }
    return data;
  }
}
