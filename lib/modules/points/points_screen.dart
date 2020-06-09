import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class PointsScreen extends StatelessWidget {
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  UserBloc _userBloc = Modular.get<UserBloc>();

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
                  trailing: StreamBuilder<UserModel>(
                    stream: _userBloc.currentUserOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
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
                        '${snapshot.data.points}',
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
          StreamBuilder<List<RequestModel>>(
              stream: _requestsBloc.indexOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator(),
                  );
                }
                List<RequestModel> _requests = snapshot.data;

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
                            _requests[index].requestDate,
                          ),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: Text(
                        '${_requests[index].owner}',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      subtitle: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pedido ${_requests[index].id}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.black26,
                                      fontSize: 14,
                                    ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Valor R\$ ${Helper.intToMoney(_requests[index].value)}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '+5',
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
                  child: RaisedButton.icon(
                    icon: item['icon'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        width: item['border'],
                        color: item['textColor'],
                      ),
                    ),
                    onPressed: item['onTap'],
                    color: item['color'],
                    elevation: 0,
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
