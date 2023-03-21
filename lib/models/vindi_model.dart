class VindiCardModel {
  String token;
  String cartaoNumber;
  int id;

  VindiCardModel({this.token, this.cartaoNumber, this.id});

  VindiCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['gateway_token'];
    cartaoNumber = json['card_number_first_six'] != null
        ? json['card_number_first_six'] +
            '000000' +
            json['card_number_last_four']
        : json['card_number_first_six'];
  }
}
