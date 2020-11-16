import 'package:central_oftalmica_app_cliente/models/item_model.dart';

class PedidoModel {
  int valor;
  String dataInclusao;
  int numeroPedido;
  int frete;
  int valorTotal;
  int itemPedido;
  String previsaoEntrega;
  String type;
  List<ItemPedidoModel> items;

  PedidoModel.fromJson(Map<String, dynamic> json) {
    valor = json['valor'];
    valorTotal = json['valor_total'];
    frete = json['frete'];
    type = json['type'];
    itemPedido = json['item_pedido'];
    previsaoEntrega = json['previsao_entrega'];
    dataInclusao = json['data_inclusao'];
    numeroPedido = json['num_pedido'];
    items = json['items']?.map<ItemPedidoModel>((e) {
      print(e);
      return ItemPedidoModel.fromJson(e);
    })?.toList();
  }

  Map<String, dynamic> toJson() {}
}
