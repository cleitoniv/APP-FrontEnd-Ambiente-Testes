import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/cliente_model.dart';
import 'package:central_oftalmica_app_cliente/models/points_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  _checkBlockedUser(context, ontap) async {
    bool blocked = await _authBloc.currentUser();
    if (blocked) {
      ontap();
    } else {
      Dialogs.errorWithWillPopScope(context,
          barrierDismissible: false,
          buttonText: "OK",
          title: "Usuario bloqueado.",
          subtitle: "No momento voce não pode realizar esse tipo de operação.");
    }
  }

  List<Map> _renderButtonData(BuildContext context) {
    return [
      {
        'title': 'Adicionar Pontos',
        'onTap': _onAddPoints,
        'border': 2.0,
        'color': Colors.white,
        'textColor': Theme.of(context).primaryColor,
        'icon': Icon(
          MaterialCommunityIcons.plus,
          size: 30,
          color: Theme.of(context).primaryColor,
        )
      },
      {
        'title': 'Resgatar Pontos',
        'onTap': _onRescuePoints,
        'border': 0.0,
        'color': Theme.of(context).accentColor,
        'textColor': Colors.white,
        'icon': Icon(
          Icons.attach_money,
          size: 25,
          color: Colors.white,
        )
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _requestsBloc.fetchPoints();
    _authBloc.fetchCurrentUser();
  }

  _onAddPoints() {
    Modular.to.pushNamed('/points/add');
  }

  _onRescuePoints() {
    Modular.to.pushNamed('/points/rescue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: Container(
          color: Theme.of(context).accentColor,
          child: Column(
            children: <Widget>[
              AppBar(
                backgroundColor: Theme.of(context).accentColor,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                title: Text(
                  'Meus pontos',
                  style: Theme.of(context).appBarTheme.textTheme.headline5,
                ),
                centerTitle: false,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 5,
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      MaterialCommunityIcons.star_four_points,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  title: Text(
                    'Saldo atual',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  trailing: StreamBuilder(
                    stream: _authBloc.clienteDataStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.loading) {
                        return Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        );
                      }
                      return Text(
                        '${snapshot.data.data.points}',
                        style: Theme.of(context).textTheme.headline6,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          StreamBuilder(
              stream: _requestsBloc.pointsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isLoading) {
                  return Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Center(
                    heightFactor: 3,
                    child: Text("Não é possivel visualizar seu histórico"),
                  );
                }
                List<PointsModel> _requests = snapshot.data.list;

                return ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _requests.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    return ListTileMoreCustomizable(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 10,
                      leading: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xffECECEC),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          Helper.dateToMonth(
                            _requests[index].dataInclusao,
                          ),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Text(
                        '${_requests[index].nome}',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pedido ${_requests[index].numPedido}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.black26,
                                      fontSize: 14,
                                    ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Valor R\$ ${Helper.intToMoney(_requests[index].valor)}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "${_requests[index].points}",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.black26,
                              fontSize: 18,
                            ),
                      ),
                    );
                  },
                );
              }),
          SizedBox(height: 10),
          Column(
            children: _renderButtonData(context).map(
              (item) {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: item['color'],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: item['border'],
                            color: item['textColor'],
                          ),
                        )),
                    icon: item['icon'],
                    onPressed: () => _checkBlockedUser(context, item["onTap"]),
                    label: Text(
                      item['title'],
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: item['textColor'],
                          ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
