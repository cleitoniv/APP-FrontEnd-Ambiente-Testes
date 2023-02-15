class VindiCardModel {
  String token;
  String cartaoNumber;

  VindiCardModel({this.token, cartaoNumber});

  VindiCardModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    cartaoNumber = json['card_number'];
  }
}
