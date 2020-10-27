import 'package:central_oftalmica_app_cliente/models/details_model.dart';

class ProductModel {
  int id;
  String produto;
  String title;
  int value;
  bool hasAcessorio;
  int tests;
  int credits;
  String imageUrl;
  String type;
  int boxes;
  String descricao;
  String material;
  int dkT;
  bool visint;
  String espessura;
  String hidratacao;
  String assepsia;
  String descarte;
  String desenho;
  String diametro;
  String nf;
  int curvaBase;
  int valueProduto;
  int valueFinan;
  String numSerie;
  String esferico;
  String group;
  int quantidade;
  bool hasEsferico;
  bool hasEixo;
  bool hasCilindrico;
  List grausEsferico;
  List grausEixo;
  List grausCilindrico;
  int previsaoEntrega;
  bool hasCor;
  bool hasAdicao;
  String enderecoEntrega;
  bool valid;
  String message;

  ProductModel(
      {this.id,
      this.title,
      this.value,
      this.tests,
      this.imageUrl,
      this.credits,
      this.type,
      this.assepsia,
      this.boxes,
      this.hidratacao,
      this.descarte,
      this.descricao,
      this.desenho,
      this.curvaBase,
      this.esferico,
      this.diametro,
      this.visint,
      this.nf,
      this.produto,
      this.espessura,
      this.valueFinan,
      this.valueProduto,
      this.group,
      this.quantidade,
      this.hasCilindrico,
      this.hasEixo,
      this.hasEsferico,
      this.hasCor,
      this.hasAdicao,
      this.grausCilindrico,
      this.grausEixo,
      this.grausEsferico,
      this.enderecoEntrega,
      this.valid,
      this.message,
      this.hasAcessorio,
      this.dkT});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    value = json['value'];
    tests = json['tests'];
    hasAcessorio = json['has_acessorio'];
    imageUrl = json['image_url'];
    credits = json['credits'];
    type = json['type'];
    nf = json['nf'];
    assepsia = json['assepsia'];
    boxes = json['boxes'];
    hidratacao = json['hidratacao'];
    descarte = json['descarte'];
    curvaBase = json['curva_base'];
    esferico = json['esferico'];
    diametro = json['diametro'];
    material = json['material'];
    visint = json['visint'];
    espessura = json['espessura'];
    desenho = json['desenho'];
    dkT = json['dk_t'];
    numSerie = json["num_serie"];
    produto = json['produto'];
    descricao = json['description'];
    valueFinan = json['value_finan'];
    valueProduto = json['value_produto'];
    group = json["group"];
    quantidade = json["quantidade"];
    hasEsferico = json["has_esferico"];
    hasEixo = json["has_eixo"];
    hasCilindrico = json["has_cilindrico"];
    grausEsferico = json["graus_esferico"];
    grausEixo = json["graus_eixo"];
    grausCilindrico = json["graus_cilindrico"];
    previsaoEntrega = json['previsao_entrega'];
    enderecoEntrega = json['end_entrega'];
    hasCor = json['has_cor'];
    hasAdicao = json['has_adicao'];
    valid = json['success'];
    message = json['mensagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['value'] = this.value;
    data['tests'] = this.tests;
    data['imageUrl'] = this.imageUrl;
    data['credits'] = this.credits;
    data['type'] = this.type;
    data['nf'] = this.nf;
    data['assepsia'] = this.assepsia;
    data['boxes'] = this.boxes;
    data['hidratacao'] = this.hidratacao;
    data['descarte'] = this.descarte;
    data['curva_base'] = this.curvaBase;
    data['esferico'] = this.esferico;
    data['diametro'] = this.diametro;
    data['material'] = this.material;
    data['visint'] = this.visint;
    data['espessura'] = this.espessura;
    data['desenho'] = this.desenho;
    data['dk_t'] = this.dkT;
    data["num_serie"] = this.numSerie;
    data['produto'] = this.produto;
    data['description'] = this.descricao;
    data['value_finan'] = this.valueFinan;
    data['value_produto'] = this.valueProduto;
    data["group"] = this.group;
    data["quantidade"] = this.quantidade;
    return data;
  }
}
