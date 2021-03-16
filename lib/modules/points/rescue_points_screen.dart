import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RescuePointsScreen extends StatefulWidget {
  final int points;

  RescuePointsScreen({this.points});

  @override
  _RescuePointsScreenState createState() => _RescuePointsScreenState();
}

class _RescuePointsScreenState extends State<RescuePointsScreen> {
  UserBloc _userBloc = Modular.get<UserBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  _onGoToFinancialCredit() {
    Modular.to.pushNamedAndRemoveUntil(
      '/home/1',
      (route) => route.isFirst,
    );
  }

  _onConfirmRescue(int points, credits) async {
    Modular.to.pop();

    PointsResult result = await _userBloc.rescuePoints(points, credits);

    if (result.isValid) {
      Dialogs.success(
        context,
        subtitle: 'Resgate realizado com sucesso!',
        buttonText: 'Ir para Crédito Financeiro',
        onTap: _onGoToFinancialCredit,
      );
    }
  }

  _onCancelRescue() {
    Modular.to.pop();
  }

  List<Map> _renderPoints(BuildContext context, int points, int credito) {
    return [
      {
        'title': 'Saldo atual de pontos',
        'color': Theme.of(context).accentColor,
        'icon': MaterialCommunityIcons.star_four_points,
        'value': points ?? 0,
      },
      {
        'title': 'Crédito Financeiro para resgate',
        'color': Theme.of(context).primaryColor,
        'icon': Icons.attach_money,
        'value': 'R\$ ${Helper.intToMoney(credito ?? 0)}'
      }
    ];
  }

  _onSubmit(int points, credits) async {
    Dialogs.confirm(
      context,
      onConfirm: () {
        _onConfirmRescue(points, credits);
      },
      onCancel: _onCancelRescue,
    );
  }

  void _fetchPoints() async {
    AuthEvent cliente = _authBloc.getAuthCurrentUser;
    _userBloc.convertPoints(cliente.data.points);
  }

  @override
  void initState() {
    super.initState();
    _fetchPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Resgatar Pontos'),
          centerTitle: false,
        ),
        body: StreamBuilder(
            stream: _userBloc.convertPointsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
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
                    children: _renderPoints(context, snapshot.data.points,
                            snapshot.data.credits)
                        .map(
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
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
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
                      onPressed: () async {
                        bool blocked =
                            await _authBloc.checkBlockedUser(context);
                        if (!blocked) {
                          _onSubmit(
                              snapshot.data.points, snapshot.data.credits);
                        }
                      },
                      child: Text(
                        'Solicitar Pontos',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  )
                ],
              );
            }));
  }
}
