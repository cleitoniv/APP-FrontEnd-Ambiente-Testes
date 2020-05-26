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
    _homeBloc.currentCreditTypeIn.add(
      'Financeiro',
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

          return Stack(
            overflow: Overflow.clip,
            children: <Widget>[
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
            ],
          );
        },
      ),
    );
  }
}
