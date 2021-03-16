import 'package:central_oftalmica_app_cliente/models/item_model.dart';

class PedidoModel {
  int valor;
  String dataInclusao;
  String paciente;
  String dataNascimento;
  String dataReposicao;
  int numeroPedido;
  int frete;
  int valorTotal;
  int itemPedido;
  String numPac;
  String previsaoEntrega;
  String type;
  List<ItemPedidoModel> items;

  PedidoModel.fromJson(Map<String, dynamic> json) {
    valor = json['valor'];
    paciente = json['paciente'];
    numPac = json['num_pac'];
    valorTotal = json['valor_total'];
    frete = json['frete'];
    type = json['type'];
    dataNascimento = json["data_nascimento"];
    dataReposicao = json['data_reposicao'];
    itemPedido = json['item_pedido'];
    previsaoEntrega = json['previsao_entrega'];
    dataInclusao = json['data_inclusao'];
    numeroPedido = json['num_pedido'];
    items = json['items']?.map<ItemPedidoModel>((e) {
      return ItemPedidoModel.fromJson(e);
    })?.toList();
  }
}
