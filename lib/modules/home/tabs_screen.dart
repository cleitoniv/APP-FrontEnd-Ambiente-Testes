import 'package:central_oftalmica_app_cliente/blocs/home_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/home_screen.dart';
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
  HomeBloc _homeBloc = Modular.get<HomeBloc>();
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _sightProblems = [
    'Todos',
    'Miopía',
    'Hipermetropia',
    'Astigmatismo',
  ];
  List<Widget> _screens = [
    HomeScreen(),
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

  _handleChangeSightProblem(String sightProblem) {
    _homeBloc.sightProblemIn.add(sightProblem);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      initialIndex: widget.index,
      length: _screens.length,
    );

    _tabController.addListener(() {
      setState(() {
        widget.index = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(),
      appBar: PreferredSize(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/drawer.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        'Antônio Fraga',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Stack(
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
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              radius: 10,
                              child: Text(
                                '2',
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
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 119,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 12,
                            child: Icon(
                              Icons.attach_money,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '5.600,00',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 76,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).accentColor,
                            radius: 12,
                            child: Icon(
                              MaterialCommunityIcons.star_four_points,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '50',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 44,
                  child: ListView.separated(
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
                      return StreamBuilder<Object>(
                          stream: _homeBloc.sightProblemOut,
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: () => _handleChangeSightProblem(
                                _sightProblems[index],
                              ),
                              child: AnimatedContainer(
                                duration: Duration(
                                  milliseconds: 150,
                                ),
                                height: 36,
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        color: _sightProblems[index] ==
                                                snapshot.data
                                            ? Color(0xffF1F1F1)
                                            : Theme.of(context).accentColor,
                                      ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(210),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          indicatorColor: Colors.transparent,
          controller: _tabController,
          tabs: _tabs.map(
            (e) {
              return Tab(
                child: Text(
                  e['title'],
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: e['id'] == widget.index
                            ? Theme.of(context).accentColor
                            : Color(0xffBFBFBF),
                        fontSize: 12,
                      ),
                ),
                icon: Image.asset(
                  'assets/icons/${e['iconName']}',
                  width: 20,
                  height: 20,
                  color: e['id'] == widget.index
                      ? Theme.of(context).accentColor
                      : Color(0xffBFBFBF),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
