class CreditCardModel {
  int id;
  String nomeTitular;
  String cartaoNumber;
  String mesValidade;
  String anoValidade;
  String ccv;
  int status;
  String token;

  CreditCardModel({
    this.id,
    this.nomeTitular,
    this.cartaoNumber,
    this.mesValidade,
    this.anoValidade,
    this.status,
    this.token,
  });

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nomeTitular = json['nome_titular'];
    cartaoNumber = json['cartao_number'];
    anoValidade = json['ano_validade'];
    mesValidade = json['mes_validade'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome_titular'] = this.nomeTitular;
    data['cartao_number'] = this.cartaoNumber;
    data['ano_validade'] = this.anoValidade;
    data['mes_validade'] = this.mesValidade;
    data['token'] = this.token;
    return data;
  }
}
