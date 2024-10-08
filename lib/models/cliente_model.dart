class ClienteModel {
  int id;
  String nome;
  String codigo;
  String loja;
  String apelido;
  String cnpjCpf;
  String ddd;
  String sitApp;
  String dataNascimento;
  String email;
  String phone;
  String diaRemessa;
  String tokenVindi;
  String modPagamento;
  int confirmationSms;
  int money;
  int status;
  int points;
  String role;
  String nomeUsuario;
  bool cadastrado;
  Map<String, dynamic> notifications;

  ClienteModel(
      {this.id,
      this.codigo,
      this.loja,
      this.cnpjCpf,
      this.role,
      this.status,
      this.nomeUsuario,
      this.sitApp,
      this.modPagamento});

  ClienteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    tokenVindi = json['token_vindi'];
    codigo = json['codigo'];
    apelido = json['apelido'];
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
    role = json['role'];
    status = json['status'];
    nomeUsuario = json['nome_usuario'];
    modPagamento = json['modpag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['codigo'] = this.codigo;
    data['loja'] = this.loja;
    data['cnpj_cpf'] = this.cnpjCpf;
    data['sit_app'] = this.sitApp;
    data['status'] = this.status;
    data['nome_usuario'] = this.nomeUsuario;
    return data;
  }
}
