import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductExtractScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: <Widget>[
        ListTileMoreCustomizable(
          contentPadding: const EdgeInsets.all(0),
          horizontalTitleGap: 0,
          leading: CircleAvatar(
            backgroundColor: Color(0xffF1F1F1),
            radius: 15,
            child: Image.asset(
              'assets/icons/open_box.png',
              width: 25,
              height: 25,
            ),
          ),
          title: Text(
            'BIOSOFT SIHY 45 CX3',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 14,
                ),
          ),
          trailing: Text(
            'Saldo: 1',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 14,
                ),
          ),
        ),
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
                  'Quantidade',
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
              'value': 2,
            },
            {
              'date': '20/08/2020',
              'request': '43564564',
              'value': 10,
            },
            {
              'date': '20/08/2020',
              'request': '43564564',
              'value': -2,
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
                      ? '${e['value']}'
                      : '+ ${e['value']}',
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
