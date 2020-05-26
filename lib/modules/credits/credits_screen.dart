import 'package:central_oftalmica_app_cliente/blocs/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  HomeBloc _homeBloc = Modular.get<HomeBloc>();
  PageController _pageController;

  _handleChangePage() async {
    String _first = await _homeBloc.currentCreditTypeOut.first;

    _pageController.animateToPage(
      _first == 'Financeiro' ? 0 : 1,
      duration: Duration(
        seconds: 1,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            left: 20,
            right: 20,
            child: StreamBuilder<String>(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, snapshot) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text(
                    snapshot.data == 'Financeiro' ? 'R\$' : 'Cx',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                  ),
                  title: Align(
                    alignment: Alignment(
                      snapshot.data == 'Financeiro' ? -1.3 : -1.17,
                      0,
                    ),
                    child: Text(
                      snapshot.data == 'Financeiro' ? '567,00' : '2',
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: 48,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
