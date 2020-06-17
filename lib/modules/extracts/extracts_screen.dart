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
    _extractWidgetBloc.extractTypeIn.add(type);

    _pageController.animateToPage(
      type == 'Financeiro' ? 0 : 1,
      duration: Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void initState() {
    super.initState();

    _extractWidgetBloc.extractTypeOut.first.then((value) {
      _pageController = PageController(
        initialPage: value == 'Financeiro' ? 0 : 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extratos de Créditos'),
        centerTitle: false,
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
