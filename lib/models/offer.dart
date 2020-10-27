class OfferModel {
  int value;
  int installmentCount;
  int desconto;

  OfferModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    installmentCount = json['installmentCount'];
    desconto = json['desconto'];
  }

  Map<String, dynamic> toJson() {}
}
