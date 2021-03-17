class CadastroModel {
  String nome;
  String bairro;
  String estado;
  String cgc;
  String cidade;
  String endereco;
  String numero;
  String crmCnae;
  String complemento;
  String emailFiscal;
  String cep;
  String dataNascimento;

  CadastroModel({this.nome});

  CadastroModel.fromJson(Map<String, dynamic> json) {
    nome = json['A1_NOME'];
    cep = json['A1_CEP'];
    bairro = json['A1_BAIRRO'];
    cgc = json['A1_CGC'];
    cidade = json['A1_MUN'];
    endereco = json['A1_END'];
    emailFiscal = json['A1_EMAIL'];
    numero = json['A1_NUM'];
    estado = json['A1_EST'];
    crmCnae = json['A1_YCRM_CNAE'];
    complemento = json['A1_COMPLEM'];
    dataNascimento = json['A1_DTNASC'];
  }
}
