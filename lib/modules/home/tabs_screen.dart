import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/home_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:flutter/material.dart';

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
  TabController _tabController;

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
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: _screens,
        ),
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
