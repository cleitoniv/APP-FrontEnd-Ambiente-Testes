import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RescuePointsScreen extends StatefulWidget {
  @override
  _RescuePointsScreenState createState() => _RescuePointsScreenState();
}

class _RescuePointsScreenState extends State<RescuePointsScreen> {
  _onGoToFinancialCredit() {
    Modular.to.pushNamedAndRemoveUntil(
      '/home/1',
      (route) => route.isFirst,
    );
  }

  _onConfirmRescue() {
    Modular.to.pop();
    Dialogs.success(
      context,
      subtitle: 'Resgate realizado com sucesso!',
      buttonText: 'Ir para Crédito Financeiro',
      onTap: _onGoToFinancialCredit,
    );
  }

  _onCancelRescue() {
    Modular.to.pop();
  }

  List<Map> _renderPoints(BuildContext context) {
    return [
      {
        'title': 'Saldo atual de pontos',
        'color': Theme.of(context).accentColor,
        'icon': MaterialCommunityIcons.star_four_points,
        'value': 50,
      },
      {
        'title': 'Crédito Financeiro para resgate',
        'color': Theme.of(context).primaryColor,
        'icon': Icons.attach_money,
        'value': 'R\$ ${Helper.intToMoney(15409)}'
      }
    ];
  }

  _onSubmit() {
    Dialogs.confirm(
      context,
      onConfirm: _onConfirmRescue,
      onCancel: _onCancelRescue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resgatar Pontos'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        children: <Widget>[
          Text(
            'Resgate seus Pontos para compras em nosso App!',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Ao resgatar, convertemos seu saldo atual de Pontos em Crédito Financeiro',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Column(
            children: _renderPoints(context).map(
              (e) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 96,
                  color: e['color'],
                  child: ListTileMoreCustomizable(
                    contentPadding: const EdgeInsets.all(20),
                    horizontalTitleGap: 10,
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        e['icon'],
                        color: e['color'],
                      ),
                    ),
                    title: Text(
                      e['title'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    trailing: Text(
                      e['value'].toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20),
            child: RaisedButton(
              onPressed: _onSubmit,
              child: Text(
                'Solicitar Pontos',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          )
        ],
      ),
    );
  }
}
