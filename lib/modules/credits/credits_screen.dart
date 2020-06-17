import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  HomeWidgetBloc _homeBloc = Modular.get<HomeWidgetBloc>();
  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();

  MoneyMaskedTextController _creditValueController;

  _onAddCredit() async {
    _creditsBloc.storeFinancialIn.add(
      Helper.moneyToInt(
        _creditValueController.numberValue,
      ),
    );

    String _first = await _creditsBloc.storeFinancialOut.first;

    if (_first != null && _first.isNotEmpty) {
      _homeBloc.valueVisibilityIn.add(false);
    }
  }

  _onTapPersonalizedValue() {
    _homeBloc.valueVisibilityIn.add(true);
  }

  @override
  void initState() {
    super.initState();
    _creditValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
  }

  @override
  void dispose() {
    _creditValueController.dispose();
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
                return ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: -5,
                  leading: Text(
                    snapshot.data == 'Financeiro' ? 'R\$' : 'Cx',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                  ),
                  title: StreamBuilder<ProductCreditModel>(
                    stream: _creditsBloc.indexProductOut,
                    builder: (context, snapshot2) {
                      if (snapshot.data != 'Financeiro' && !snapshot2.hasData) {
                        return Center(
                          heightFactor: 2,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        );
                      }
                      return StreamBuilder<FinancialCreditModel>(
                        stream: _creditsBloc.indexFinancialOut,
                        builder: (context, snapshot3) {
                          if (snapshot.data == 'Financeiro' &&
                              !snapshot3.hasData) {
                            return Center(
                              heightFactor: 2,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            );
                          }
                          return Text(
                            snapshot.data == 'Financeiro'
                                ? Helper.intToMoney(snapshot3.data.balance)
                                : '${snapshot2.data.total}',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      fontSize: 48,
                                    ),
                          );
                        },
                      );
                    },
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: snapshot.data == 'Financeiro'
                            ? Icon(
                                Icons.attach_money,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              )
                            : Image.asset(
                                'assets/icons/open_box.png',
                                width: 25,
                                height: 25,
                              ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        snapshot.data == 'Financeiro'
                            ? 'Saldo atual'
                            : 'Total de Produtos',
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height / 2.2,
            child: Container(
              padding: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<String>(
                stream: _homeBloc.currentCreditTypeOut,
                builder: (context, snapshot) {
                  String _currentType = snapshot.data;
                  return StreamBuilder<ProductCreditModel>(
                    stream: _creditsBloc.indexProductOut,
                    builder: (context, snapshot) {
                      if (_currentType != 'Financeiro' && !snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      ProductCreditModel _productCredits = snapshot.data;
                      return StreamBuilder<FinancialCreditModel>(
                        stream: _creditsBloc.indexFinancialOut,
                        builder: (context, snapshot) {
                          if (_currentType == 'Financeiro' &&
                              !snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          FinancialCreditModel _financialCredits =
                              snapshot.data;

                          return ListView.separated(
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _currentType == 'Financeiro'
                                ? _financialCredits.credits.length
                                : _productCredits.products.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 20,
                            ),
                            itemBuilder: (context, index) {
                              return _currentType == 'Financeiro'
                                  ? CardWidget(
                                      parcels: _financialCredits
                                          .credits[index].parcels,
                                      value: _financialCredits
                                          .credits[index].value,
                                    )
                                  : ProductWidget(
                                      credits: _productCredits
                                          .products[index].credits,
                                      tests:
                                          _productCredits.products[index].tests,
                                      imageUrl: _productCredits
                                          .products[index].imageUrl,
                                      title:
                                          _productCredits.products[index].title,
                                    );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: StreamBuilder<String>(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, snapshot) {
                return StreamBuilder<bool>(
                  stream: _homeBloc.valueVisibilityOut,
                  builder: (context, snapshot2) {
                    if (snapshot2.hasData && snapshot2.data) {
                      return Column(
                        children: <Widget>[
                          TextFieldWidget(
                            labelText: 'Digite o valor',
                            controller: _creditValueController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icon(
                              Icons.attach_money,
                              color: Color(0xffa1a1a1),
                            ),
                          ),
                          SizedBox(height: 20),
                          RaisedButton(
                            elevation: 0,
                            onPressed: _onAddCredit,
                            child: Text(
                              'Adicionar Crédito',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return RaisedButton(
                        elevation: 0,
                        onPressed: _onTapPersonalizedValue,
                        child: Text(
                          snapshot.data == 'Financeiro'
                              ? 'Valor Personalizado'
                              : 'Comprar Crédito de Produto',
                          style: Theme.of(context).textTheme.button,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
