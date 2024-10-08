class ItemPedidoModel {
  String paciente;
  String dataNascimento;
  String numPac;
  List<Map<String, dynamic>> items;

  ItemPedidoModel.fromJson(Map<String, dynamic> json) {
    paciente = json['paciente'];
    dataNascimento = json['data_nascimento'];
    numPac = json['num_pac'];
    items = json['items']?.map<Map<String, dynamic>>((e) {
      return {
        "valorProduto": e['valor_produto'],
        "valor": e['valor'],
        "imageUrl": e['url_image'],
        "produto": e['nome_produto'],
        "quantidade": e['quantidade'],
        "valorTotal": e['valor_total'],
        "olho": e['olho'],
        "esfericoD": e['esferico_d'] ?? '-',
        "eixoD": e['eixo_d'] ?? '-',
        "adicaoD": e['adicao_d']?.trim() == '' ? '-' : e['adicao_d']?.trim() ?? '-',
        "cilindricoD": e['cilindro_d'] ?? '-',
        "esfericoE": e['esferico_e'] ?? '-',
        "cilindricoE": e['cilindro_e'] ?? '-',
        "eixoE": e['eixo_e'] ?? '-',
        "adicaoE": e['adicao_e']?.trim() == '' ? '-' : e['adicao_e']?.trim() ?? '-',
        "qtdD": e["qtd_d"] ?? 0,
        "qtdE": e["qtd_e"] ?? 0,
        "duracao": e['duracao'],
        "tipoVenda": e["type"],
        "operation": e["operation"],
        "tests": e["tests"],
        "produto_teste": e["produto_teste"]
      };
    })?.toList();
  }
}
