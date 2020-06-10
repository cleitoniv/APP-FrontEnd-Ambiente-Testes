class CreditCardModel {
  int id;
  String owner;
  String number;
  String validity;
  String securityCode;

  CreditCardModel({
    this.id,
    this.owner,
    this.number,
    this.validity,
    this.securityCode,
  });

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    number = json['number'];
    validity = json['validity'];
    securityCode = json['security_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['owner'] = this.owner;
    data['number'] = this.number;
    data['validity'] = this.validity;
    data['security_code'] = this.securityCode;
    return data;
  }
}
