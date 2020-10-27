class ExtratoProdutoModel {
  String produto;
  List items;
  int saldo;

  ExtratoProdutoModel({this.produto, this.items, this.saldo});

  ExtratoProdutoModel.fromJson(Map<String, dynamic> json) {
    saldo = json['saldo'];
    items = json['items'];
    produto = json['produto'];
  }

  Map<String, dynamic> toJson() {}
}
