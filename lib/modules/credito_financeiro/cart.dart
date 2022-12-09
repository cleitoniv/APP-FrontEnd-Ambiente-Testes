import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CreditCartScreen extends StatefulWidget {
  @override
  _CreditCartScreenState createState() => _CreditCartScreenState();
}

class _CreditCartScreenState extends State<CreditCartScreen> {
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  int _taxaEntrega = 0;

  bool _lock = false;

  _onBackToPurchase() {
    _homeWidgetBloc.currentTabIndexIn.add(1);
    _homeWidgetBloc.currentRequestTypeIn.add("Produto");
    Modular.to.pushNamed("/home/1");
  }

  _onSubmit() {
    List _cartItems = _requestsBloc.cartItems;

    if (_cartItems.length <= 0) {
      Map<String, dynamic> error = {
        "Atenção": ["Voce precisa selecionar um meio de pagamento!"]
      };
      SnackBar _snackbar = ErrorSnackBar.snackBar(this.context, error);
      _scaffoldKey.currentState.showSnackBar(_snackbar);
    }

    _requestsBloc.taxaEntregaSink.add(_taxaEntrega);

    setState(() {
      this._lock = false;
    });

    Modular.to.pushNamed(
      '/cart/payment',
    );
  }

  _removeItem(Map<String, dynamic> data) {
    int _total = _cartWidgetBloc.currentCartTotalItems;
    if (data["removeItem"] == "Sim") {
      _cartWidgetBloc.cartTotalItemsSink.add(_total - 2);
    } else {
      _cartWidgetBloc.cartTotalItemsSink.add(_total - 1);
    }

    _requestsBloc.removeFromCart(data);
  }

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["operation"] == "03" ||
          element["operation"] == "04") {
        return previousValue;
      }
      return previousValue + (element['product'].value * element['quantity']);
    });

    return Helper.intToMoney(_total);
  }

  @override
  Widget build(BuildContext context) {
    if (_lock) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
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
                        style: Theme.of(context).textTheme.headline6.copyWith(
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
                          errorBuilder: (context, url, error) => Image.asset(
                              'assets/images/no_image_product.jpeg'),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.black38,
                                    fontSize: 14,
                                  ),
                            ),
                            SizedBox(width: 20),
                            CircleAvatar(
                                backgroundColor: Helper.buyTypeBuild(
                                    context,
                                    _data[index]['operation'],
                                    _data[index]['tests'])['color'],
                                radius: 10,
                                child: Helper.buyTypeBuild(
                                    context,
                                    _data[index]['operation'],
                                    _data[index]['tests'])['icon']),
                            SizedBox(width: 5),
                            Text(
                              '${Helper.buyTypeBuild(context, _data[index]['operation'], _data[index]['tests'])['title']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'R\$ ${Helper.intToMoney(_data[index]['value'])}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  onPressed: _lock
                                      ? null
                                      : () {
                                          _removeItem(_data[index]);
                                        },
                                ))
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Color(0xffF1F1F1), elevation: 0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Continue Comprando',
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Theme.of(context).accentColor,
                        ),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          disabledBackgroundColor:
                              Theme.of(context).accentColor),
                      child: Text(
                        'Finalizar Pedido',
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: snapshot.data.isEmpty
                          ? null
                          : () {
                              setState(() {
                                this._lock = true;
                              });
                              _onSubmit();
                            },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
