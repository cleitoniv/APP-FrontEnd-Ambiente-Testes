class OfferModel {
  int value;
  int installmentCount;
  int discount;
  int quantity;
  int price;
  int total;
  int percentageTest;

  OfferModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    installmentCount = json['installmentCount'];
    discount = json['discount'];
    quantity = json['quantity'];
    percentageTest = json['percentage_test'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {}
}
