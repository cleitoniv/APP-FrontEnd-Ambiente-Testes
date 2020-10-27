class EnderecoModel {
  String logradouro;
  String ibge;
  String localidade;
  String complemento;
  String cep;
  String uf;
  String bairro;

  EnderecoModel(
      {this.logradouro, this.ibge, this.localidade, this.cep, this.bairro});

  EnderecoModel.fromJson(Map<String, dynamic> json) {
    logradouro = json['logradouro'];
    ibge = json['ibge'];
    localidade = json['localidade'];
    complemento = json['complemento'];
    uf = json['uf'];
    bairro = json['bairro'];
    cep = json['cep'];
  }

  Map<String, dynamic> toJson() {}
}
