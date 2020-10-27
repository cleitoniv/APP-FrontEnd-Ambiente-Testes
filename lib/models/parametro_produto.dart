class ParametroProdutoModel {
  List cor;
  List grausAdicao;
  List grausCilindrico;
  List grausEixo;
  List grausEsferico;

  ParametroProdutoModel.fromJson(Map<String, dynamic> json) {
    cor = json['cor'];
    grausAdicao = json['graus_adicao'];
    grausEixo = json['graus_eixo'];
    grausEsferico = json['graus_esferico'];
    grausCilindrico = json['graus_cilindrico'];
  }

  Map<String, dynamic> toJson() {}
}
