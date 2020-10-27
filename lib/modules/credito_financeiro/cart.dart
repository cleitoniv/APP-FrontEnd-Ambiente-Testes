import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CreditCartScreen extends StatefulWidget {
  @override
  _CreditCartScreenState createState() => _CreditCartScreenState();
}

class _CreditCartScreenState extends State<CreditCartScreen> {
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();

  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();

  _onBackToPurchase() {
    _homeWidgetBloc.currentTabIndexIn.add(0);
    Modular.to.pushNamed("/credito_financeiro/produto");
  }

  _onSubmit() {
    Modular.to.pushNamed(
      '/cart/payment',
    );
  }

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(
      0,
      (previousValue, element) =>
          previousValue + (element['product'].value * element['quantity']),
    );

    return Helper.intToMoney(_total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho', style: Theme.of(context).textTheme.headline4),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _requestsBloc.cartOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data.isEmpty) {
                  return Center(
                    heightFactor: 3,
                    child: Text(
                      'Seu carrinho está vazio',
                      style: Theme.of(context).textTheme.title.copyWith(
                            color: Color(0xffa1a1a1),
                            fontSize: 14,
                          ),
                    ),
                  );
                }

                List<Map<String, dynamic>> _data = snapshot.data;
                return ListView.separated(
                  primary: false,
                  addSemanticIndexes: true,
                  shrinkWrap: true,
                  itemCount: _data.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 25,
                    thickness: 1,
                    color: Colors.black12,
                  ),
                  itemBuilder: (context, index) {
                    return ListTileMoreCustomizable(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 10,
                      leading: Image.network(
                        _data[index]['product'].imageUrl,
                      ),
                      title: Text(
                        '${_data[index]['product'].title}',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            'Qnt. ${_data[index]['quantity']}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Colors.black38,
                                      fontSize: 14,
                                    ),
                          ),
                          SizedBox(width: 20),
                          CircleAvatar(
                              backgroundColor: Helper.buyTypeBuild(
                                context,
                                _data[index]['type'],
                              )['color'],
                              radius: 10,
                              child: Helper.buyTypeBuild(
                                context,
                                _data[index]['type'],
                              )['icon']),
                          SizedBox(width: 5),
                          Text(
                            '${Helper.buyTypeBuild(
                              context,
                              _data[index]['type'],
                            )['title']}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'R\$ ${Helper.intToMoney(_data[index]['product'].value)}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                            color: Theme.of(context).accentColor,
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(
              height: 25,
              thickness: 1,
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Taxa de entrega',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                      ),
                ),
                Text(
                  'R\$ ${Helper.intToMoney(0)}',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 18,
                      ),
                ),
                StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _requestsBloc.cartOut,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? 'R\$ ${_totalToPay(snapshot.data)}'
                            : '',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 18,
                            ),
                      );
                    }),
              ],
            ),
            SizedBox(height: 30),
            RaisedButton.icon(
              color: Color(0xffF1F1F1),
              elevation: 0,
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).accentColor,
              ),
              label: Text(
                'Continue Comprando',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Theme.of(context).accentColor,
                    ),
              ),
              onPressed: _onBackToPurchase,
            ),
            SizedBox(height: 20),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: _requestsBloc.cartOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Opacity(
                  opacity: snapshot.data.isEmpty ? 0.5 : 1,
                  child: RaisedButton(
                    elevation: 0,
                    child: Text(
                      'Finalizar Pedido',
                      style: Theme.of(context).textTheme.button,
                    ),
                    disabledColor: Theme.of(context).accentColor,
                    onPressed: snapshot.data.isEmpty ? null : _onSubmit,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
