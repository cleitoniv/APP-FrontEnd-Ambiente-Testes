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
      child: StreamBuilder<String>(
        stream: _homeBloc.currentCreditTypeOut,
        builder: (context, snapshot) {
          _handleChangePage();

          return PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
              ),
              Container(
                color: Color(0xffEFC75E),
              ),
            ],
          );
        },
      ),
    );
  }
}
