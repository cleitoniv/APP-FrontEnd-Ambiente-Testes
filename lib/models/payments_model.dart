class PaymentModel {
  int id;
  String vencimento;
  String nf;
  int valor;
  String method;
  int status;
  String codigoBarra;

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vencimento = json['vencimento'];
    nf = json['nf'];
    codigoBarra = json["codigo_barra"];
    valor = json["valor"];
    method = json["method"];
    status = json["status"];
  }
}
