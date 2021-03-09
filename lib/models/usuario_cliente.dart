class UsuarioClienteModel {
  String nome;
  String email;
  int id;
  String cargo;
  int status;

  UsuarioClienteModel({this.nome, this.email, this.cargo, this.status});

  UsuarioClienteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    cargo = json['cargo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {}
}
