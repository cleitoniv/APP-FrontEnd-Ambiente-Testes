class CreditCardModel {
  int id;
  String nome_titular;
  String cartao_number;
  String mes_validade;
  String ano_validade;
  String ccv;
  int status;

  CreditCardModel({
    this.id,
    this.nome_titular,
    this.cartao_number,
    this.mes_validade,
    this.ano_validade,
    this.status,
  });

  CreditCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nome_titular = json['nome_titular'];
    cartao_number = json['cartao_number'];
    ano_validade = json['ano_validade'];
    mes_validade = json['mes_validade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome_titular'] = this.nome_titular;
    data['cartao_number'] = this.cartao_number;
    data['ano_validade'] = this.ano_validade;
    data['mes_validade'] = this.mes_validade;
    return data;
  }
}
