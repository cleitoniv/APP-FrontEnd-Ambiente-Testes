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
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _onBackToPurchase() {
    _homeWidgetBloc.currentTabIndexIn.add(0);
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
    Modular.to.pushNamed(
      '/cart/payment',
    );
  }

  String _totalToPay(List<Map<String, dynamic>> data) {
    int _total = data.fold(0, (previousValue, element) {
      if (element["operation"] == "07" || element["operation"] == "00") {
        return previousValue;
      }
      return previousValue + (element['product'].value * element['quantity']);
    });

    return Helper.intToMoney(_total);
  }

  String selectPrice(Map<String, dynamic> item) {
    if (item["operation"] == "07") {
      return 'R\$ ${Helper.intToMoney(item['product'].valueProduto)}';
      // return Helper.intToMoney(item['product'].valueProduto);
    } else if (item["operation"] == "13") {
      return 'R\$ ${Helper.intToMoney(item['product'].valueFinan)}';
      // return Helper.intToMoney(item['product'].valueFinan);
    } else if (item["operation"] == "01") {
      return 'R\$ ${Helper.intToMoney(item['product'].value)}';
    } else if (item["operation"] == "01" && item['tests'] == "Sim") {
      return '';
    } else if (item["operation"] == "00") {
      return '';
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                      leading: _data[index]["tests"] != "Sim" &&
                              _data[index]["type"] != "T"
                          ? Image.network(
                              _data[index]['product'].imageUrl,
                              errorBuilder: (context, url, error) =>
                                  Image.asset(
                                      'assets/images/no_image_product.jpeg'),
                            )
                          : Image.network(
                              _data[index]['product'].imageUrlTest,
                              errorBuilder: (context, url, error) =>
                                  Image.asset(
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
                                  _data[index]['operation'],
                                  _data[index]['tests'])['color'],
                              radius: 10,
                              child: Helper.buyTypeBuild(
                                  context,
                                  _data[index]['operation'],
                                  _data[index]['tests'])['icon']),
                          SizedBox(width: 5),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '${Helper.buyTypeBuild(context, _data[index]['operation'], _data[index]['tests'])['title']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            selectPrice(_data[index]),
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: _data[index]['removeItem'] == 'Sim' ||
                                      _data[index]['removeItem'] == null
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _removeItem(_data[index]);
                                      },
                                    )
                                  : Container())
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
            RaisedButton(
              color: Color(0xffF1F1F1),
              elevation: 0,
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
                  child: RaisedButton(
                    elevation: 0,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Finalizar Pedido',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    disabledColor: Theme.of(context).accentColor,
                    onPressed: snapshot.data.isEmpty
                        ? null
                        : () async {
                            bool blocked =
                                await _authBloc.checkBlockedUser(context);
                            if (!blocked) {
                              _onSubmit();
                            }
                          },
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
