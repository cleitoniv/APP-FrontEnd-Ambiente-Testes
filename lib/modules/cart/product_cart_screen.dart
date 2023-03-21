// import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/requests_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductCartScreen extends StatefulWidget {
  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  int _taxaEntrega = 0;
  bool _lock = false;
  StreamSubscription _productCartReset;

  _onBackToPurchase() {
    Modular.to.pushNamed("/home/0");
  }

  _removeItemCard() {
    _cartWidgetBloc.cartTotalItemsSink.add(0);
  }

  _onSubmit() {
    _requestsBloc.taxaEntregaSink.add(_taxaEntrega);

    List<Map<String, dynamic>> _data = _requestsBloc.cartItems;

    int _total = _data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" ||
          element["operation"] == "13" ||
          element["type"] == "T") {
        return previousValue;
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

  _onSubmitDialog() {
    _requestsBloc.getPedidosList(0);
    _authBloc.fetchCurrentUser();
    Modular.to.pushNamedAndRemoveUntil(
      '/home/3',
      (route) => route.isFirst,
    );
  }

  bool hasPrice(Map<String, dynamic> item) {
    return item["operation"] != "03" && item["operation"] != "04";
  }

  _orderFinish(List<Map<String, dynamic>> _data) async {
    OrderPayment _order = await _requestsBloc.orderPayment(_data);

    if (_order.isValid) {
      _requestsBloc.resetCart();
      _removeItemCard();
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

  String selectPrice(Map<String, dynamic> item) {
    if (item["type"] == "T") {
      item.update("operation", (value) => "03");
    }

    if (item["operation"] == "07" && item['tests'] == "Não") {
      return 'R\$ ${Helper.intToMoney(item['product'].valueProduto)}';
      // return Helper.intToMoney(item['product'].valueProduto);
    } else if (item["operation"] == "07" && item['tests'] == "Sim") {
      return '';
    } else if (item["operation"] == "13" && item['tests'] == "Sim") {
      return '';
    } else if (item["operation"] == "13") {
      return 'R\$ ${Helper.intToMoney(item['product'].valueFinan)}';
    } else if (item["operation"] == "01" && item['tests'] == "Sim") {
      return '';
    } else if (item["operation"] == "01" && item['tests'] == "Não") {
      return 'R\$ ${Helper.intToMoney(item['product'].value)}';
    } else if (item["operation"] == "03") {
      return '';
    }
    return "";
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
      if (element["type"] == "T" || element["tests"] == "Sim") {
        return previousValue;
      } else if (element["operation"] == "13") {
        return previousValue +
            (element['product'].valueFinan * element['quantity']);
      } else if (element["operation"] == "07") {
        return previousValue +
            (element['product'].valueProduto * element['quantity']);
      }
      return previousValue + (element['product'].value * element['quantity']);
    });

    return Helper.intToMoney(_total + _taxaEntrega);
  }

  @override
  void dispose() {
    this._lock = null;
    // _productCartReset.cancel();
    super.dispose();
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
    return WillPopScope(
      onWillPop: () async => false,
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          appBar: AppBar(
            title:
                Text('Carrinho', style: Theme.of(context).textTheme.headline4),
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
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
                    return Helper.CartList(
                        _data, hasPrice, _removeItem, selectPrice);
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
                              if (snapshot.data.isEmpty &&
                                  snapshot.data == null) {
                                return Container();
                              }
                              if (snapshot.data.isEmpty == true) {
                                return Container();
                              }
                              List<Map<String, dynamic>> _data = snapshot.data;
                              List days = [];
                              for (var i = 0; i < _data.length; i++) {
                                if (_data[i]['operation'] == '06') {
                                  days.add(0);
                                } else {
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
                        child: Text(
                          'Finalizar Pedido',
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: _lock || snapshot.data.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _lock = true;
                                  _onSubmit();
                                });
                              },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
