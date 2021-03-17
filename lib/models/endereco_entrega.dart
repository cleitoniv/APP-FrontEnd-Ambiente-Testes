class EnderecoEntregaModel {
  String endereco;
  String numero;
  String complemento;
  String municipio;
  String bairro;
  String cep;

  EnderecoEntregaModel(
      {this.endereco,
      this.numero,
      this.complemento,
      this.municipio,
      this.bairro,
      this.cep});

  EnderecoEntregaModel.fromJson(Map<String, dynamic> json) {
    endereco = json['endereco'];
    numero = json['numero'];
    complemento = json['complemento'];
    municipio = json['cidade'];
    bairro = json['bairro'];
    cep = json['cep'];
  }
}
