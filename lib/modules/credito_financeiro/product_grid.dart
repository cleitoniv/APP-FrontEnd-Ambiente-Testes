import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/notifications_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/modules/cart/cart_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product_grid_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credits/credits_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/drawer_widget.dart';
import 'package:central_oftalmica_app_cliente/modules/products/products_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/requests/requests_screen.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditProductGridScreen extends StatefulWidget {
  int index;
  AuthEvent auth;

  CreditProductGridScreen({this.index = 0});

  @override
  _CreditProductGridScreenState createState() =>
      _CreditProductGridScreenState();
}

class _CreditProductGridScreenState extends State<CreditProductGridScreen>
    with SingleTickerProviderStateMixin {
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  NotificationBloc _notificationBloc = Modular.get<NotificationBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> _sightProblems = [
    'Todos',
    'Miopía',
    'Hipermetropia',
    'Astigmatismo',
  ];
  List<Widget> _screens = [ProductsScreen()];
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

    int _status;

    if (type != _first) {
      switch (type) {
        case 'Pendentes':
          _status = 0;
          break;
        case 'Entregues':
          _status = 1;
          break;
        case 'Reposição':
          _status = 2;
          break;
      }

      _requestsBloc.getPedidosList(_status);
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
  }

  _initState() async {
    _productBloc.fetchProducts("Todos");
  }

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Credito Produto',
              style: Theme.of(context).textTheme.headline4),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 40,
              child: _renderHeaderFilters(0),
            ),
            Expanded(child: ProductsGridScreen(), flex: 8)
          ],
        ));
  }
}
