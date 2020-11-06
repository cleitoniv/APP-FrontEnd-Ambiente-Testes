class ClienteModel {
  int id;
  String nome;
  String codigo;
  String loja;
  String cnpjCpf;
  String ddd;
  String sitApp;
  String dataNascimento;
  String email;
  String phone;
  String diaRemessa;
  int confirmationSms;
  int money;
  int points;
  bool cadastrado;
  Map<String, dynamic> notifications;
  ClienteModel({this.id, this.codigo, this.loja, this.cnpjCpf});

  ClienteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    codigo = json['codigo'];
    ddd = json['ddd'];
    loja = json['loja'];
    cnpjCpf = json['cnpj_cpf'];
    dataNascimento = json['data_nascimento'];
    email = json['email'];
    phone = json['telefone'];
    sitApp = json['sit_app'];
    diaRemessa = json['dia_remessa'];
    money = json['money'];
    points = json['points'];
    notifications = json['notifications'];
    cadastrado = json['cadastrado'];
    confirmationSms = json['confirmation_sms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['codigo'] = this.codigo;
    data['loja'] = this.loja;
    data['cnpj_cpf'] = this.cnpjCpf;
    data['sit_app'] = this.sitApp;
    return data;
  }
}
