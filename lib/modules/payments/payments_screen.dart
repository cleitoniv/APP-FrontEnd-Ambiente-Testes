import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/payments_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentsWidgetBloc _paymentsWidgetBloc = Modular.get<PaymentsWidgetBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _onChangePaymentType(String value) {
    _paymentsWidgetBloc.paymentTypeIn.add(value);

    String _filtro = "0";

    if (value == "Pagos") {
      _filtro = "1";
    } else if (value == "Vencidas") {
      _filtro = "2";
    }

    _paymentsWidgetBloc.fetchPayments(_filtro);
  }

  _onExpandItem() {}

  _showSnackBar() {
    SnackBar _snackBar = SnackBar(
      content: Text(
        'Texto copiado para área de transferência',
      ),
    );

    _scaffoldKey.currentState.showSnackBar(
      _snackBar,
    );
  }

  Image _getIcon(String method) {
    switch (method) {
      case "CREDIT_CARD":
        return Image.asset(
          "assets/icons/credit_card.png",
          width: 30,
          height: 30,
        );
        break;
      case "BOLETO":
        return Image.asset(
          "assets/icons/barcode.png",
          width: 30,
          height: 30,
        );
        break;
      case "CREDIT_FINAN":
        return Image.asset(
          "assets/icons/credito-financeiro.png",
          width: 30,
          height: 30,
        );
        break;
      case "CREDIT_PRODUCT":
        return Image.asset(
          "assets/icons/credito-produto.png",
          width: 30,
          height: 30,
        );
        break;
    }
  }

  _onCopyBarcode(String code) {
    ClipboardData data = ClipboardData(text: code);
    Clipboard.setData(data);

    _showSnackBar();
  }

  Widget _renderBarCode(PaymentModel e) {
    if (e.method == "BOLETO") {
      return Text(
        "${e.codigoBarra}",
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black38,
              fontSize: 12,
            ),
      );
    } else {
      return Container();
    }
  }

  Icon _renderTrailIcon(PaymentModel e) {
    if (e.method == "BOLETO") {
      return Icon(
        Icons.keyboard_arrow_down,
        size: 25,
        color: Theme.of(context).accentColor,
      );
    } else {
      Container();
    }
  }

  Widget _renderCopyBarCode(PaymentModel e) {
    if (e.method == "BOLETO") {
      return RaisedButton(
        onPressed: () => _onCopyBarcode("${e.codigoBarra}"),
        child: Text(
          'Copiar Código de Barra',
          style: Theme.of(context).textTheme.button,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget dataWidget(PaymentModel e) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xfff),
          borderRadius: BorderRadius.circular(5),
        ),
        child: _getIcon(e.method),
      ),
      title: Table(
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
              Text(
                'NF',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
              Text(
                'Valor',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              )
            ],
          ),
          TableRow(
            children: [
              Text(
                "${e.vencimento}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 13,
                    ),
              ),
              Text(
                "${e.nf}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 13,
                    ),
              ),
              Text(
                'R\$ ${Helper.intToMoney(e.valor)}',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 13,
                    ),
              )
            ],
          )
        ],
      ),
      trailing: Container(
        height: 5,
        width: 10,
      ),
    );
  }

  Widget boletoWidget(PaymentModel e) {
    return ExpansionTile(
        onExpansionChanged: (value) => _onExpandItem(),
        children: <Widget>[
          SizedBox(height: 10),
          _renderBarCode(e),
          SizedBox(height: 30),
          _renderCopyBarCode(e)
        ],
        leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xfff),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _getIcon(e.method)),
        title: Table(
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
                Text(
                  'NF',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                ),
                Text(
                  'Valor',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                )
              ],
            ),
            TableRow(
              children: [
                Text(
                  "${e.vencimento}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                ),
                Text(
                  "${e.nf}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                        fontSize: 13,
                      ),
                ),
                Text(
                  'R\$ ${Helper.intToMoney(e.valor)}',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 13,
                      ),
                )
              ],
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    int filter = _paymentsWidgetBloc.currentFilter;
    _paymentsWidgetBloc.fetchPayments("${filter}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                        child: Text(
                          type,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: type == snapshot.data
                                  ? Color(0xffF1F1F1)
                                  : Color(0xff828282),
                              fontSize: 13),
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
                    stream: _paymentsWidgetBloc.paymentsListStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                        return Center(
                          child: Text(
                              "Nao há pagamentos a serem visualizados no momento."),
                        );
                      }

                      return Column(
                        children: snapshot.data.list.map<Widget>((e) {
                          if (typeSnapshot.data == "Pagos") {
                            return dataWidget(e);
                          } else if (e.method == "BOLETO") {
                            return boletoWidget(e);
                          } else {
                            return dataWidget(e);
                          }
                        }).toList(),
                      );
                    });
              }),
        ],
      ),
    );
  }
}
