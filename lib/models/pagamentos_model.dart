import 'package:intl/intl.dart';

class PagamentosModel {
  String notaFiscal;
  num valor;
  String emissao;
  String dataPagamento;
  String vencimento;
  String vencimentoReal;
  String parcelas;

  PagamentosModel.fromJson(Map<String, dynamic> json) {
    notaFiscal = json['NF'];
    valor = json["VALOR"];
    emissao = json['EMISSAO'];
    vencimento = json['VENCTO'];
    dataPagamento = json["DTPG"];
    vencimentoReal = json["VENCTOREAL"];
    parcelas = json["PARC"];
  }
}
