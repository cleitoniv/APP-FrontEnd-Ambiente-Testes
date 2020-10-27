class DevolutionModel {
  Map<String, dynamic> product;
  int quantidade;
  String group;

  DevolutionModel({this.product, this.quantidade, this.group});

  DevolutionModel.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    quantidade = json['quantidade'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {}
}
