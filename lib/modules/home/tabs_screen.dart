import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/drawer_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/products/products_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TabsScreen extends StatefulWidget {
  int index;

  TabsScreen({
    this.index = 0,
  });

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  NotificationBloc _notificationBloc = Modular.get<NotificationBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _sightProblems = [
    'Todos',
    'Miopía',
    'Hipermetropia',
    'Astigmatismo',
  ];
  List<Widget> _screens = [
    ProductsScreen(),
    CreditsScreen(),
    CartScreen(),
    RequestsScreen(),
  ];
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
    _homeWidgetBloc.sightProblemIn.add(sightProblem);
  }

  _onChangeCreditType(String type) {
    _homeWidgetBloc.currentCreditTypeIn.add(type);
  }

  int _countNotifications(
    List<NotificationModel> notifications,
  ) {
    return notifications
        .where(
          (item) => !item.isRead,
        )
        .length;
  }

  _onChangeRequestType(String type) async {
    String _first = await _homeWidgetBloc.currentRequestTypeOut.first;

    _homeWidgetBloc.currentRequestTypeIn.add(type);

    String _status;

    if (type != _first) {
      switch (type) {
        case 'Pendentes':
          _status = 'pendent';
          break;
        case 'Entregues':
          _status = 'delivered';
          break;
        case 'Reposição':
          _status = 'replacement';
          break;
      }

      _requestsBloc.indexIn.add({
        'status': _status,
      });
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

  Widget _renderHeaderFilters(int index) {
    switch (index) {
      case 0:
        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: _sightProblems.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 10,
          ),
          itemBuilder: (context, index) {
            return StreamBuilder<String>(
              stream: _homeWidgetBloc.sightProblemOut,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () => _onChangeSightProblem(
                    _sightProblems[index],
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
                      color: _sightProblems[index] == snapshot.data
                          ? Theme.of(context).accentColor
                          : Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      _sightProblems[index],
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: _sightProblems[index] == snapshot.data
                                ? Color(0xffF1F1F1)
                                : Theme.of(context).accentColor,
                          ),
                    ),
                  ),
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
                      child: Text(
                        type,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: type == snapshot.data
                                  ? Color(0xffF1F1F1)
                                  : Theme.of(context).accentColor,
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
            'Reposição',
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
                      child: Text(
                        type,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              color: type == snapshot.data
                                  ? Color(0xffF1F1F1)
                                  : Color(0xff828282),
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
    }
  }

  _initState() async {
    _tabController.addListener(() {
      _homeWidgetBloc.currentTabIndexIn.add(
        _tabController.index,
      );
    });

    _homeWidgetBloc.currentTabIndexOut.listen((int event) {
      if (event != null && event != _tabController.index) {
        _tabController.index = event;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _homeWidgetBloc.currentTabIndexIn.add(
      widget.index,
    );

    _tabController = TabController(
      vsync: this,
      initialIndex: widget.index,
      length: _screens.length,
    );

    _initState();

    // _homeWidgetBloc.currentTabIndexOut.listen((event) {}).onData((event) {
    //   print('Etrou Bloc');
    //   return _tabController.index = event;
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _homeWidgetBloc.currentCreditTypeOut,
      builder: (context, snapshot) {
        return StreamBuilder<int>(
          stream: _homeWidgetBloc.currentTabIndexOut,
          builder: (context, snapshot2) {
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: snapshot2.data == 1
                  ? snapshot.data == 'Financeiro'
                      ? Theme.of(context).primaryColor
                      : Color(0xffEFC75E)
                  : Theme.of(context).scaffoldBackgroundColor,
              drawer: DrawerWidget(
                onClose: _onCloseDrawer,
                onNavigate: _onNavigateDrawer,
                onExitApp: _onExitApp,
              ),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(200),
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
                  child: SafeArea(
                    child: StreamBuilder<int>(
                      stream: _homeWidgetBloc.currentTabIndexOut,
                      builder: (context, snapshot) {
                        return Column(
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
                                  Text(
                                    'Antônio Fraga',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  GestureDetector(
                                    onTap: _handleNotifications,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/icons/bell.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: StreamBuilder<
                                                  List<NotificationModel>>(
                                              stream:
                                                  _notificationBloc.indexOut,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container();
                                                }
                                                if (_countNotifications(
                                                        snapshot.data) ==
                                                    0) {
                                                  return Container();
                                                }
                                                return CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  radius: 10,
                                                  child: Text(
                                                    '${_countNotifications(snapshot.data)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                );
                                              }),
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
                                    width: 119,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          radius: 12,
                                          child: Icon(
                                            Icons.attach_money,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          Helper.intToMoney(350090),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: Theme.of(context).accentColor,
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
                                              Theme.of(context).accentColor,
                                          radius: 12,
                                          child: Icon(
                                            MaterialCommunityIcons
                                                .star_four_points,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '50',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor,
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
                                snapshot.data,
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: _screens,
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
                            return Tab(
                              child: Text(
                                e['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      color: e['id'] == snapshot.data
                                          ? Theme.of(context).accentColor
                                          : Color(0xffBFBFBF),
                                      fontSize: 12,
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
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
