import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/extrato_finan.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class FinancialExtractScreen extends StatelessWidget {
  ExtractWidgetBloc _extractWidgetBloc = Modular.get<ExtractWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _extractWidgetBloc.extratoFinanceiroStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
                child: Text("Nao foi possivel carregar seu extrato."));
          }

          AuthEvent _authEvent = _authBloc.getAuthCurrentUser;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              Text(
                "${snapshot.data.financeiro.date}",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ListTileMoreCustomizable(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 0,
                trailing: Text(
                  'Saldo: ${Helper.intToMoney(_authEvent.data.money)}',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 18, color: Colors.green),
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
                children: snapshot.data.financeiro.data.map<TableRow>((e) {
                  return TableRow(
                    children: [
                      Text(
                        "${e['date']}",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black26,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${e['pedido']}",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black26,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        (e['valor'] as int) <= 0
                            ? 'R\$ ${Helper.intToMoney(e['valor'])}'
                            : '+ R\$ ${Helper.intToMoney(e['valor'])}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 14,
                              color: (e['valor'] as int) <= 0
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
        });
  }
}
