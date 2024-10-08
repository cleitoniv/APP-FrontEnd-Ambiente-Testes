// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  var listToTakeOperations = [];
  bool _lock = false;

  _onBackToPurchase() {
    // _homeWidgetBloc.currentTabIndexIn.add(0);
    Modular.to.pop();
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

  _onSubmitDialog() {
    _requestsBloc.getPedidosList(0);
    _authBloc.fetchCurrentUser();
    Modular.to.pushNamedAndRemoveUntil(
      '/home/3',
      (route) => route.isFirst,
    );
  }

  _orderFinish(List<Map<String, dynamic>> _data) async {
    OrderPayment _order = await _requestsBloc.orderPayment(_data);

    if (_order.isValid) {
      _requestsBloc.resetCart();
      _cartWidgetBloc.cartTotalItemsSink.add(0);
      Dialogs.success(
        context,
        subtitle: 'Compra efetuada com sucesso!',
        buttonText: 'Ir para Meus Pedidos',
        onTap: _onSubmitDialog,
      );
    } else {
      SnackBar _snack = ErrorSnackBar.snackBar(this.context, _order.error);
      _scaffoldKey.currentState.showSnackBar(
        _snack,
      );
    }
  }

  _onSubmit() async {
    List<Map<String, dynamic>> _data = _requestsBloc.cartItems;

    int _total = _data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" || element["operation"] == "13") {
        return previousValue;
      } else if (element["type"] == "T") {
        return previousValue +
            (element['product'].valueTest * element['quantity']);
      }
      return previousValue + (element['product'].value * element['quantity']);
    });

    if (_total == 0) {
      return _orderFinish(_data);
    }

    setState(() {
      this._lock = false;
    });
    Modular.to.pushNamed(
      '/cart/payment',
    );
  }

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "13" ||
          element["operation"] == "07" ||
          element["operation"] == "03" ||
          element["operation"] == "04") {
        return previousValue;
      }
      return previousValue + (element['product'].value * element['quantity']);
    });

    return Helper.intToMoney(_total);
  }

  bool hasPrice(Map<String, dynamic> item) {
    return item["operation"] != "07" &&
        item["operation"] != "03" &&
        item["operation"] != "04" &&
        item["operation"] != "13";
  }

  String selectPrice(Map<String, dynamic> item) {
    // if (item["operation"] == "01" && item["tests"] == "Sim")
    if (item["operation"] != "03" && item["tests"] == "Sim")
      return 'R\$ ${Helper.intToMoney(item['product'].valueTest)}';
    if (item["operation"] == "13")
      return 'R\$ ${Helper.intToMoney(item['product'].valueFinan)}';
    if (item["operation"] == "07")
      return 'R\$ ${Helper.intToMoney(item['product'].valueProduto)}';
    return 'R\$ ${Helper.intToMoney(item['product'].value)}';
  }

//  String selectPrice(Map<String, dynamic> item) {
//    if (item["operation"] == "07") {
//      return 'R\$ ${Helper.intToMoney(item['product'].valueProduto)}';
//      // return Helper.intToMoney(item['product'].valueProduto);
//    } else if (item["operation"] == "13") {
//      return 'R\$ ${Helper.intToMoney(item['product'].valueFinan)}';
//      // return Helper.intToMoney(item['product'].valueFinan);
//    } else if (item["operation"] == "01") {
//      return 'R\$ ${Helper.intToMoney(item['product'].value)}';
//    } else if (item["operation"] == "01" && item['tests'] == "Sim") {
//      return '';
//    } else if (item["operation"] == "00") {
//      return '';
//    }
//    return "";
//  }
  _getTextByTypeOperation(list) {
      if (list.contains('01')) {
        return 'Avulso';
      } else if (list.contains('06') || list.contains('07')) {
        return 'de Crédito de Produto';
      } else if (list.contains('13')) {
        return 'de Crédito Financeiro';
      } else {
        return 'de Remessa de Testes';
      } 
  }
  _getMaxDaysCart(data) {
    var ver = data.map((e) {
      if (e['operation'] == '06') {
        return 0;
      } else {
        return e['meta']['days'];
      }
    }).toList();

    return ver.reduce((curr, next) => curr > next ? curr : next);
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
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              StreamBuilder(
                stream: _requestsBloc.cartOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      heightFactor: 3,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData && snapshot.data.length <= 0) {
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
                  var operations = _data.map((e) {
                      return e['operation'];
                    }).toList();
                    if (listToTakeOperations.length != operations.length) {
                      Future.delayed(const Duration(milliseconds: 1), () {
                      setState(() {
                       listToTakeOperations = operations;
                      });
                    });
                    }
                  return Column(
                    children: [
                      listToTakeOperations.length > 0 
                      ? Text('Pedido ${_getTextByTypeOperation(listToTakeOperations)}', style: Theme.of(context).textTheme.headline4)
                      : Text(''),
                      Helper.CartList(
                          _data, hasPrice, _removeItem, selectPrice),
                    ],
                  );
                },
              ),
              Divider(
                height: 25,
                thickness: 1,
                color: Colors.black12,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      Text(
                        'Previsão de entrega',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 18,
                            ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _requestsBloc.cartOut,
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.hasData
                                  ? 'R\$ ${_totalToPay(snapshot.data)}'
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            );
                          }),
                      StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _requestsBloc.cartOut,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            if (snapshot.data.isEmpty) {
                              return Container();
                            }
                            List<Map<String, dynamic>> _data = snapshot.data;
                            List days = [];
                            for (var i = 0; i < _data.length; i++) {
                              if (_data[i]['operation'] == '06' || _data[i]['operation'] == '07') {
                                days.add(0);
                              } else  {
                                days.add(_data[i]['meta']['days']);
                              }
                            }
                            days.sort(((a, b) => -a.compareTo(b)));
                            return Text(
                              snapshot.hasData == true &&
                                      _getMaxDaysCart(_data) > 0
                                  ? '${_getMaxDaysCart(_data)} dias úteis.'
                                  : '7 dias úteis.',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 18,
                                  ),
                            );
                          })
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xffF1F1F1), elevation: 0),
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
                          onSurface: Theme.of(context).accentColor,
                          elevation: 0),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Finalizar Pedido',
                          style: Theme.of(context).textTheme.button,
                        ),
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
