import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';

class FinancialExtractScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        Text(
          'Fevereiro/2019',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Table(
          border: TableBorder.symmetric(
            outside: BorderSide(
              width: 0.2,
            ),
          ),
          children: [
            TableRow(
              children: [
                Text(
                  'Data',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Pedido',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Valor',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        Table(
          border: TableBorder.all(
            width: 0.2,
          ),
          children: [
            {
              'date': '20/08/2020',
              'request': '43564564',
              'value': 20000,
            },
            {
              'date': '20/08/2020',
              'request': '43564564',
              'value': -2000,
            },
            {
              'date': '20/08/2020',
              'request': '43564564',
              'value': 20000,
            },
          ].map((e) {
            return TableRow(
              children: [
                Text(
                  e['date'],
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  e['request'],
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  (e['value'] as int) <= 0
                      ? 'R\$ ${Helper.intToMoney(e['value'])}'
                      : '+ R\$ ${Helper.intToMoney(e['value'])}',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 14,
                        color: (e['value'] as int) <= 0
                            ? Colors.black26
                            : Theme.of(context).primaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
