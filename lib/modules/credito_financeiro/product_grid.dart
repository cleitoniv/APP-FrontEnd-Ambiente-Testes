import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product_grid_screen.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditProductGridScreen extends StatefulWidget {
  final int index;
  final AuthEvent auth;

  CreditProductGridScreen({this.index = 0, this.auth});

  @override
  _CreditProductGridScreenState createState() =>
      _CreditProductGridScreenState();
}

class _CreditProductGridScreenState extends State<CreditProductGridScreen>
    with SingleTickerProviderStateMixin {
  ProductBloc _productBloc = Modular.get<ProductBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  TabController _tabController;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  _onChangeSightProblem(String sightProblem) {
    _productBloc.fetchProducts(sightProblem);
    _homeWidgetBloc.sightProblemIn.add(sightProblem);
  }

  Widget _renderHeaderFilters(int index) {
    return StreamBuilder(
      stream: _productBloc.productListStream,
      builder: (context, productSnapshot) {
        if (!productSnapshot.hasData || productSnapshot.data.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (!productSnapshot.hasData || productSnapshot.data.isEmpty) {
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
                      color:
                          productSnapshot.data.filters[index] == snapshot.data
                              ? Theme.of(context).accentColor
                              : Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      productSnapshot.data.filters[index],
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: productSnapshot.data.filters[index] ==
                                    snapshot.data
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
