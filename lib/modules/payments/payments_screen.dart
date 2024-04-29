import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/payments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../helper/dialogs.dart';
import '../../models/pagamentos_model.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentsWidgetBloc _paymentsWidgetBloc = Modular.get<PaymentsWidgetBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  _onChangePaymentType(String value) {
    _paymentsWidgetBloc.paymentTypeIn.add(value);

    String _filtro = "0";

    if (value == "Pagos") {
      _filtro = "1";
    } else if (value == "Vencidas") {
      _filtro = "2";
    }

    _paymentsWidgetBloc.fetchPagamentos();
  }

  // _onExpandItem() {}

  // _showSnackBar() {
  //   SnackBar _snackBar = SnackBar(
  //     content: Text(
  //       'Texto copiado para área de transferência',
  //     ),
  //   );

  //   _scaffoldKey.currentState.showSnackBar(
  //     _snackBar,
  //   );
  // }

  // Image _getIcon(String method) {
  //   switch (method) {
  //     case "CREDIT_CARD":
  //       return Image.asset(
  //         "assets/icons/credit_card.png",
  //         width: 30,
  //         height: 30,
  //       );
  //     case "BOLETO":
  //       return Image.asset(
  //         "assets/icons/barcode.png",
  //         width: 30,
  //         height: 30,
  //       );
  //     case "CREDIT_FINAN":
  //       return Image.asset(
  //         "assets/icons/credito-financeiro.png",
  //         width: 30,
  //         height: 30,
  //       );
  //     case "CREDIT_PRODUCT":
  //       return Image.asset(
  //         "assets/icons/credito-produto.png",
  //         width: 30,
  //         height: 30,
  //       );
  //     default:
  //       return Image.asset(
  //         "assets/icons/credit_card.png",
  //         width: 30,
  //         height: 30,
  //       );
  //   }
  // }

  // _onCopyBarcode(String code) {
  //   ClipboardData data = ClipboardData(text: code);
  //   Clipboard.setData(data);

  //   _showSnackBar();
  // }

  // Widget _renderBarCode(PagamentosModel e) {
    // if (e.method == "BOLETO") {
    //   return Text(
    //     "${e.codigoBarra}",
    //     style: Theme.of(context).textTheme.subtitle1.copyWith(
    //           fontWeight: FontWeight.w600,
    //           color: Colors.black38,
    //           fontSize: 12,
    //         ),
    //   );
    // } else {
    //   return Container();
    // }
  // }

  // Widget _renderCopyBarCode(PagamentosModel e) {
    // if (e.method == "BOLETO") {
    //   return ElevatedButton(
    //     onPressed: () => _onCopyBarcode("${e.codigoBarra}"),
    //     child: Text(
    //       'Copiar Código de Barra',
    //       style: Theme.of(context).textTheme.button,
    //     ),
    //   );
    // } else {
    //   return Container();
    // }
  // }
  _separador(PagamentosModel e, botao) {
    var dataHoje = "${DateTime.now().year}" + "${_mes()}" + "${DateTime.now().day}";
    if (int.parse(e.vencimentoReal) > int.parse(dataHoje) && e.dataPagamento == " " && botao == "À Vencer") {
      return e;
    } else if (e.dataPagamento != " " && botao == "Pagos") {
      return e;
    } else if (int.parse(e.vencimentoReal) < int.parse(dataHoje) && e.dataPagamento.length < 2 && botao == "Vencidas") {
      return e;
    }
  }

  Widget dataWidget(PagamentosModel e, botao) {
    var realItens = _separador(e, botao);
    if (realItens == null) {
       
      ; 
      return Container(); 
    } else
    return ListTile(
      title: Table(
        // border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid),
        // top: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid),
        // bottom: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid),
        // right: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid),
        // left: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)
        // ),
        children: [
          TableRow(
            children: [
              Text(
                'Venc.',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
              Center(
                child: Text(
                  'NF',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
              ),
              Center(
                child: Text(
                  'Valor',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
              ),
              Center(
                child: Text(
                  'Parcelas',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
              )
            ],
          ),
          TableRow(
            children: [
              Text(
                "${realItens.vencimentoReal}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 13,
                    ),
              ),
              Text(
                "${realItens.notaFiscal}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 13,
                    ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                'R\$ ${Helper.intToMoney((realItens.valor * 10000) ~/ 100)}',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 13,
                    ),
              ),
              ),
              Center(
                child: Text(
                  "${realItens.parcelas}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _mes() {
    int data = DateTime.now().month;
    if (data < 10) {
      return "0$data";
    } else {
      return data;
    }
  }

  @override
  void initState() {
    super.initState();
    int filter = _paymentsWidgetBloc.currentFilter;
    _paymentsWidgetBloc.fetchPagamentos();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pagamentos'),
          centerTitle: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                'À Vencer',
                'Pagos',
                'Vencidas',
              ].map(
                (type) {
                  return StreamBuilder<String>(
                    stream: _paymentsWidgetBloc.paymentTypeOut,
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () => _onChangePaymentType(
                          type,
                        ),
                        child: AnimatedContainer(
                          height: 44,
                          width: MediaQuery.of(context).size.width / 3.7,
                          duration: Duration(
                            milliseconds: 50,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: type != snapshot.data
                                ? Border.all(
                                    width: 0.5,
                                    color: Colors.black12,
                                  )
                                : null,
                            color: type == snapshot.data
                                ? Theme.of(context).accentColor
                                : Color(0xffF1F1F1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: type == 'À Vencer'
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              topLeft: type == 'À Vencer'
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              bottomRight: type == 'Vencidas'
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                              topRight: type == 'Vencidas'
                                  ? Radius.circular(5)
                                  : Radius.circular(0),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              type,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      color: type == snapshot.data
                                          ? Color(0xffF1F1F1)
                                          : Color(0xff828282),
                                      fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 30),
            StreamBuilder(
                stream: _paymentsWidgetBloc.paymentTypeOut,
                builder: (context, typeSnapshot) {
                  return StreamBuilder(
                      stream: _paymentsWidgetBloc.pagamentosListStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                          return Center(
                            child: Text(
                                "Não há pagamentos a serem visualizados no momento."),
                          );
                        }
                        return Column(
                          children: snapshot.data.list.reversed.toList().map<Widget>((e) {
                              return dataWidget(e, typeSnapshot.data);
                          }).toList(),
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }
}
