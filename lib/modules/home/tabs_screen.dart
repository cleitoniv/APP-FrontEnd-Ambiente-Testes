import 'dart:async';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/drawer_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/products/products_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TabsScreen extends StatefulWidget {
  final int index;
  final ProductModel product;

  TabsScreen({this.index = 0, this.product});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  TabController _tabController;
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _screens;

  List<Map> _tabs = [
    {
      'id': 0,
      'title': 'Início',
      'iconName': 'home.png',
    },
    {
      'id': 1,
      'title': 'Créditos',
      'iconName': 'wallet.png',
    },
    {
      'id': 2,
      'title': 'Carrinho',
      'iconName': 'cart.png',
    },
    {
      'id': 3,
      'title': 'Pedidos',
      'iconName': 'requests.png',
    },
  ];

  _onChangeSightProblem(String sightProblem) {
    _productBloc.fetchProducts(sightProblem);
    _homeWidgetBloc.sightProblemIn.add(sightProblem);
  }

  _onChangeCreditType(String type) {
    if (type == "Produto") {
      _productBloc.offersRedirectedSink.add(null);
      _productBloc.productRedirectedSink.add(null);
    }
    _homeWidgetBloc.currentCreditTypeIn.add(type);
  }

  _onChangeRequestType(String type) async {
    String _first = await _homeWidgetBloc.currentRequestType;

    _homeWidgetBloc.currentRequestTypeIn.add(type);

    int _status;

    if (type != _first) {
      switch (type) {
        case 'Pendentes':
          _status = 0;
          break;
        case 'Entregues':
          _status = 1;
          break;
        // case 'Reposição':
        //   _status = 2;
        //   break;
      }
      _requestsBloc.currentRequestFilterSink.add(_status);
      _requestsBloc.getPedidosList(_status);
    }
  }

  _verifyTextScaleFactor(double size) {
    if (size < 1.5) {
      return 200.0;
    } else {
      return 240.0;
    }
  }

  _verifyTextScaleFactorMoney(double size) {
    if (size < 1.5) {
      return 119.0;
    } else {
      return 143.0;
    }
  }

  _handleOpenDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  _onCloseDrawer() {
    Modular.to.pop();
  }

  _handleNotifications() {
    Modular.to.pushNamed(
      '/notifications',
    );
  }

  _onNavigateDrawer(int index) {
    String _route;

    if (index == 1) {
      int filter = _requestsBloc.currentFilter;
      _requestsBloc.getPedidosList(filter);
    }

    switch (index) {
      case 0:
        _route = '/profile';
        break;
      case 1:
        _tabController.index = 3;
        break;
      case 2:
        _tabController.index = 1;
        break;
      case 3:
        _route = '/notifications';
        break;
      case 4:
        _route = '/devolution';
        break;
      case 5:
        _route = '/points';
        break;
      case 6:
        _route = '/payments';
        break;
      case 7:
        _route = '/extracts';
        break;
      case 8:
        _route = '/requests/reposition';
        break;
      case 9:
        _route = '/help';
        break;
      default:
    }

    _onCloseDrawer();

    if (_route != null) {
      Modular.to.pushNamed(_route);
    }
  }

  _handleMyCredits() {
    _tabController.index = 1;
  }

  _handleMyPoints() {
    Modular.to.pushNamed('/points');
  }

  _onExitApp() async {
    await _authBloc.signOutOut.first;

    Modular.to.pushNamedAndRemoveUntil(
      '/auth/login',
      (route) => route.isFirst,
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text('Você realmente deseja sair?'),
        actions: [
          TextButton(
            child: Text(
              'Sim',
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 14),
            ),
            onPressed: _onExitApp,
          ),
          SizedBox(width: 20),
          TextButton(
            child: Text(
              'Não',
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 14),
            ),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    );
  }

  Widget _renderHeaderFilters(int index) {
    switch (index) {
      case 0:
        return StreamBuilder(
          stream: _productBloc.productListStream,
          builder: (context, productSnapshot) {
            if (!productSnapshot.hasData || productSnapshot.data.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (!productSnapshot.hasData ||
                productSnapshot.data.isEmpty) {
              return Container();
            }

            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: productSnapshot.data.filters.length,
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
              itemBuilder: (context, index) {
                return StreamBuilder<String>(
                  stream: _homeWidgetBloc.sightProblemOut,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () => _onChangeSightProblem(
                        productSnapshot.data.filters[index],
                      ),
                      child: AnimatedContainer(
                        duration: Duration(
                          milliseconds: 50,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: productSnapshot.data.filters[index] ==
                                  snapshot.data
                              ? Theme.of(context).accentColor
                              : Color(0xffF1F1F1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            productSnapshot.data.filters[index],
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                  color: productSnapshot.data.filters[index] ==
                                          snapshot.data
                                      ? Color(0xffF1F1F1)
                                      : Theme.of(context).accentColor,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            'Financeiro',
            'Produto',
          ].map(
            (type) {
              return StreamBuilder<String>(
                stream: _homeWidgetBloc.currentCreditTypeOut,
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () => _onChangeCreditType(
                      type,
                    ),
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width / 2.2,
                      duration: Duration(
                        milliseconds: 50,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: type == snapshot.data
                            ? Theme.of(context).accentColor
                            : Color(0xffF1F1F1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: type == 'Financeiro'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          topLeft: type == 'Financeiro'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          bottomRight: type != 'Financeiro'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          topRight: type != 'Financeiro'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          type,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: type == snapshot.data
                                    ? Color(0xffF1F1F1)
                                    : Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            'Pendentes',
            'Entregues',
          ].map(
            (type) {
              return StreamBuilder<String>(
                stream: _homeWidgetBloc.currentRequestTypeOut,
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () => _onChangeRequestType(
                      type,
                    ),
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width / 3.2,
                      duration: Duration(
                        milliseconds: 50,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: type != snapshot.data
                            ? Border.all(
                                width: 0.5,
                                color: Colors.black12,
                              )
                            : null,
                        color: type == snapshot.data
                            ? Theme.of(context).accentColor
                            : Color(0xffF1F1F1),
                        borderRadius: BorderRadius.only(
                          bottomLeft: type == 'Pendentes'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          topLeft: type == 'Pendentes'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          bottomRight: type == 'Reposição'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                          topRight: type == 'Reposição'
                              ? Radius.circular(5)
                              : Radius.circular(0),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          type,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                color: type == snapshot.data
                                    ? Color(0xffF1F1F1)
                                    : Color(0xff828282),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      default:
        return Container();
    }
  }

  _initState() async {
    print("1");
    await _authBloc.fetchCurrentUser();
    String _currentProdFilter = _homeWidgetBloc.currentSightProblem;
    print("2");
    if (_currentProdFilter != null) {
      print("3");
      _productBloc.fetchProducts(_currentProdFilter);
    } else {
      print("4");
      _productBloc.fetchProducts("Todos");
    }
    print("g5");
    print("5");

    _tabController.addListener(() {
      _homeWidgetBloc.currentTabIndexIn.add(
        _tabController.index,
      );
    });

    print("6");

    int filter = _requestsBloc.currentFilter;

    _requestsBloc.getPedidosList(filter);

    print("7");
    _homeWidgetBloc.currentTabIndexOut.listen((int event) {
      if (event != null && event != _tabController.index) {
        _tabController.index = event;
      }
    });

    print("8");
  }

  _getCurrentStatus() async {
    var _cliente = await _authBloc.getCurrentStatus();
    if (_cliente == 0) {
      await _authBloc.signOutOut.first;

      Modular.to.pushNamedAndRemoveUntil(
        '/auth/login',
        (route) => route.isFirst,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    this._screens = [
      ProductsScreen(),
      CreditsScreen(
        product: widget.product,
      ),
      CartScreen(),
      RequestsScreen(),
    ];

    _homeWidgetBloc.currentTabIndexIn.add(
      widget.index,
    );

    _tabController = TabController(
      vsync: this,
      initialIndex: widget.index,
      length: _screens.length,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging && _tabController.index == 3) {
        int filter = _requestsBloc.currentFilter;

        _requestsBloc.getPedidosList(filter);
      } else if (_tabController.indexIsChanging && _tabController.index == 0) {
        String currentSightProblem = _homeWidgetBloc.currentSightProblem;
        _productBloc.fetchProducts(currentSightProblem);
      }
    });
    _initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: StreamBuilder<String>(
        stream: _homeWidgetBloc.currentCreditTypeOut,
        builder: (context, snapshot) {
          return StreamBuilder<int>(
            stream: _homeWidgetBloc.currentTabIndexOut,
            builder: (context, snapshot2) {
              return ScaffoldMessenger(
                child: Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: snapshot2.data == 1
                      ? snapshot.data == 'Financeiro'
                          ? Theme.of(context).primaryColor
                          : Colors.white
                      : Theme.of(context).scaffoldBackgroundColor,
                  drawer: DrawerWidget(
                    onClose: _onCloseDrawer,
                    onNavigate: _onNavigateDrawer,
                    onExitApp: _onExitApp,
                  ),
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(_verifyTextScaleFactor(
                        MediaQuery.of(context).textScaleFactor)),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: StreamBuilder(
                          stream: _authBloc.clienteDataStream,
                          builder: (context, authEventSnapshot) {
                            if (!authEventSnapshot.hasData ||
                                authEventSnapshot.data.loading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              // _getCurrentStatus();
                              return SafeArea(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: _handleOpenDrawer,
                                          child: Image.asset(
                                            'assets/icons/drawer.png',
                                            width: 30,
                                            height: 30,
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.contain,
                                          child: Text(
                                            authEventSnapshot.data.data
                                                        .nomeUsuario !=
                                                    null
                                                ? authEventSnapshot
                                                    .data.data.nomeUsuario
                                                : authEventSnapshot
                                                    .data.data.apelido,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _handleNotifications,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/icons/bell.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                              Positioned(
                                                right: -2,
                                                top: -2,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  radius: 10,
                                                  child: Text(
                                                    "${authEventSnapshot.data.data.notifications["opens"]}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: _handleMyCredits,
                                        child: Container(
                                          width: _verifyTextScaleFactorMoney(
                                              MediaQuery.of(context)
                                                  .textScaleFactor),
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                radius: 12,
                                                child: Icon(
                                                  Icons.attach_money,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              // aqui money
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  Helper.intToMoney(
                                                      authEventSnapshot
                                                          .data.data.money),
                                                  overflow: TextOverflow.fade,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                        fontSize: 14.0,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: _handleMyPoints,
                                        child: Container(
                                          width: 76,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              CircleAvatar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                radius: 12,
                                                child: Icon(
                                                  MaterialCommunityIcons
                                                      .star_four_points,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "${authEventSnapshot.data.data.points}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 44,
                                    child: _renderHeaderFilters(
                                      snapshot2.data,
                                    ),
                                  )
                                ],
                              ));
                            }
                          },
                        )),
                  ),
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    // children: _screens,
                    children: _screens.map((e) {
                      if (e.toString() == "ProductsScreen") {
                        return ProductsScreen(
                          context: context,
                        );
                      }
                      return e;
                    }).toList(),
                  ),
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: SafeArea(
                      child: TabBar(
                        indicatorColor: Colors.transparent,
                        controller: _tabController,
                        tabs: _tabs.map(
                          (e) {
                            return StreamBuilder<int>(
                              stream: _homeWidgetBloc.currentTabIndexOut,
                              builder: (context, snapshot) {
                                if (e['id'] != 2) {
                                  return Tab(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        e['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: e['id'] == snapshot.data
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : Color(0xffBFBFBF),
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                    icon: Image.asset(
                                      'assets/icons/${e['iconName']}',
                                      width: 20,
                                      height: 20,
                                      color: e['id'] == snapshot.data
                                          ? Theme.of(context).accentColor
                                          : Color(0xffBFBFBF),
                                    ),
                                  );
                                } else {
                                  return Tab(
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        e['title'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: e['id'] == snapshot.data
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : Color(0xffBFBFBF),
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                    icon: Stack(
                                      children: [
                                        StreamBuilder(
                                          stream: _cartWidgetBloc
                                              .cartTotalItemsStream,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData ||
                                                snapshot.data == 0) {
                                              return Container();
                                            }
                                            return Align(
                                              alignment: Alignment.bottomRight,
                                              child: CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.red,
                                                child: Text(
                                                  "${snapshot.data}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Center(
                                          child: Image.asset(
                                            'assets/icons/${e['iconName']}',
                                            width: 23,
                                            height: 23,
                                            color: e['id'] == snapshot.data
                                                ? Theme.of(context).accentColor
                                                : Color(0xffBFBFBF),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      onWillPop: _onWillPop,
    );
  }
}
