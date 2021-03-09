import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/modules/extracts/financial_extract_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/extracts/product_extract_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ExtractsScreen extends StatefulWidget {
  @override
  _ExtractsScreenState createState() => _ExtractsScreenState();
}

class _ExtractsScreenState extends State<ExtractsScreen> {
  ExtractWidgetBloc _extractWidgetBloc = Modular.get<ExtractWidgetBloc>();
  PageController _pageController;

  _onChangeExtractType(String type) {
    if (type == "Financeiro") {
      _extractWidgetBloc.fetchExtratoFinanceiro();
    } else {
      _extractWidgetBloc.fetchExtratoProduto();
    }

    int _pageIndex = 0;

    if (type != "Financeiro") {
      _pageIndex = 1;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _pageIndex,
        duration: Duration(seconds: 1),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      _extractWidgetBloc.extractTypeIn.add(type);
    }
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> currentPage = _extractWidgetBloc.currentPageValue;
    if (currentPage['type'] == "Financeiro") {
      _extractWidgetBloc.fetchExtratoFinanceiro();
    } else {
      _extractWidgetBloc.fetchExtratoProduto();
    }
    _pageController = PageController(
      initialPage: currentPage['page'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extratos de Créditos'),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () {
            Modular.to.pushNamedAndRemoveUntil(
              '/home/0',
              (route) => route.isFirst,
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xffA1A1A1),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              'Financeiro',
              'Produto',
            ].map(
              (type) {
                return StreamBuilder<String>(
                  stream: _extractWidgetBloc.extractTypeOut,
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () => _onChangeExtractType(
                        type,
                      ),
                      child: AnimatedContainer(
                        height: 44,
                        width: MediaQuery.of(context).size.width / 3,
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
                                    ? Colors.white
                                    : Color(0xff828282),
                              ),
                        ),
                      ),
                    );
                  },
                );
              },
            ).toList(),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                FinancialExtractScreen(),
                ProductExtractScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
