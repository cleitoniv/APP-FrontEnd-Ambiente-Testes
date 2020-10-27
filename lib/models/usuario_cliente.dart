class UsuarioClienteModel {
  String nome;
  String email;
  int id;
  String cargo;

  UsuarioClienteModel({this.nome, this.email, this.cargo});

  UsuarioClienteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    cargo = json['cargo'];
  }

  Map<String, dynamic> toJson() {}
}
