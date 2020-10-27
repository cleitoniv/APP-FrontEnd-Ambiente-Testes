class PointsModel {
  String dataInclusao;
  int valor;
  String nome;
  String points;
  String numPedido;

  PointsModel.fromJson(Map<String, dynamic> json) {
    valor = json['valor'];
    nome = json['nome'];
    points = json['points'];
    numPedido = json['num_pedido'];
    dataInclusao = json['inclusao'];
  }
}
