class OfferModel {
  int value;
  int installmentCount;
  int installmentCountB;
  int installmentCountC;
  double discount;
  int quantity;
  int price;
  int total;
  int percentageTest;

  OfferModel.fromJson(Map<String, dynamic> json) {
    print('desconto vindo do backend');
    print(json['discount']);
    value = json['value'];
    installmentCount = json['installmentCount'];
    installmentCountB = json['installmentCountB'];
    installmentCountC = json['installmentCountC'];
    discount = json['discount'];
    quantity = json['quantity'];
    percentageTest = json['percentage_test'];
    price = json['price'];
    total = json['total'];
  }
}
