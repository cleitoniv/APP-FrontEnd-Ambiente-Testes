class OfferModel {
  int value;
  int installmentCount;
  int desconto;
  int quantity;
  int price;
  int total;

  OfferModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    installmentCount = json['installmentCount'];
    desconto = json['desconto'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {}
}
