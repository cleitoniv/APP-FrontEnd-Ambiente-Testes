import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtractsScreen extends StatelessWidget {
  ExtractWidgetBloc _extractWidgetBloc = Modular.get<ExtractWidgetBloc>();

  _onChangeExtractType(String type) {
    _extractWidgetBloc.extractTypeIn.add(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extratos de Créditos'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              'Financeiro',
              'Produto',
            ].map(
              (type) {
                return StreamBuilder<String>(
                  stream: _extractWidgetBloc.extractTypeOut,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () => _onChangeExtractType(
                        type,
                      ),
                      child: AnimatedContainer(
                        height: 44,
                        width: MediaQuery.of(context).size.width / 3,
                        duration: Duration(
                          milliseconds: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: type == snapshot.data
                              ? Theme.of(context).accentColor
                              : Color(0xffF1F1F1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: type == 'Financeiro'
                                ? Radius.circular(5)
                                : Radius.circular(0),
                            topLeft: type == 'Financeiro'
                                ? Radius.circular(5)
                                : Radius.circular(0),
                            bottomRight: type != 'Financeiro'
                                ? Radius.circular(5)
                                : Radius.circular(0),
                            topRight: type != 'Financeiro'
                                ? Radius.circular(5)
                                : Radius.circular(0),
                          ),
                        ),
                        child: Text(
                          type,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: type == snapshot.data
                                    ? Colors.white
                                    : Color(0xff828282),
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
                'value': 20000,
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
                    '+ R\$ ${Helper.intToMoney(e['value'])}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
