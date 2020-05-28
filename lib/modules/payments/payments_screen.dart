import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class PaymentsScreen extends StatelessWidget {
  PaymentsWidgetBloc _paymentsWidgetBloc = Modular.get<PaymentsWidgetBloc>();

  _onChangePaymentType(String value) {
    _paymentsWidgetBloc.paymentTypeIn.add(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamentos'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
                          width: MediaQuery.of(context).size.width / 3.35,
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
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: type == snapshot.data
                                          ? Color(0xffF1F1F1)
                                          : Color(0xff828282),
                                    ),
                          ),
                        ),
                      );
                    });
              },
            ).toList(),
          ),
          SizedBox(height: 30),
          ListTileMoreCustomizable(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 20,
            leading: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xffECECEC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                'assets/icons/barcode.png',
                width: 30,
                height: 30,
              ),
            ),
            title: Table(
              children: [
                TableRow(
                  children: [
                    Text(
                      'Venc.',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'NF',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'Valor',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text(
                      '30/03/20',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      '6848529',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontSize: 14,
                          ),
                    ),
                    Text(
                      'R\$ ${Helper.intToMoney(20000)}',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 14,
                          ),
                    )
                  ],
                )
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }
}
