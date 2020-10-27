import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
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

  ProductBloc _productsBloc = Modular.get<ProductBloc>();

  MoneyMaskedTextController _creditValueController;

  CreditoFinanceiroBloc _creditoFinanceiroBloc =
      Modular.get<CreditoFinanceiroBloc>();

  AuthBloc _authBloc = Modular.get<AuthBloc>();

  AuthEvent _currentUser;

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

  _onTapPersonalizedValue(String type) {
    // _homeBloc.valueVisibilityIn.add(true);
    if (type == "Financeiro") {
      Modular.to.pushNamed('/credito_financeiro');
    } else {
      Modular.to.pushNamed('/credito_financeiro/produto');
    }
  }

  _onTapSelectProduct(ProductModel product) {
    _creditsBloc.currentProductSink.add(product);
  }

  void _addCreditoFinanceiro(OfferModel offer) {
    _creditoFinanceiroBloc.creditoFinaceiroSink.add(CreditoFinanceiro(
        valor: offer.value,
        installmentCount: offer.installmentCount,
        desconto: 0));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  @override
  void initState() {
    super.initState();
    _productsBloc.fetchCreditProducts("Todos");
    _currentUser = _authBloc.getAuthCurrentUser;
    _creditsBloc.indexFinancialIn.add(_currentUser);
    _creditsBloc.fetchOffers();
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
                  title: StreamBuilder(
                    stream: _creditsBloc.currentProductStream,
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
                      return StreamBuilder(
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
                          return Row(
                            children: [
                              Text(
                                snapshot.data == 'Financeiro'
                                    ? Helper.intToMoney(
                                        snapshot3.data.data.money)
                                    : '${snapshot2.data.boxes}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      fontSize: 48,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  snapshot.data == 'Financeiro'
                                      ? ''
                                      : '${snapshot2.data.title}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              )
                            ],
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
                  return StreamBuilder(
                    stream: _productsBloc.creditProductListStream,
                    builder: (context, productSnapshot) {
                      if (_currentType != 'Financeiro' &&
                              !productSnapshot.hasData ||
                          productSnapshot.data.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      ProductList _productCredits = productSnapshot.data;
                      return StreamBuilder(
                        stream: _creditsBloc.offerStream,
                        builder: (context, offerSnapshot) {
                          if (_currentType == 'Financeiro' &&
                                  !offerSnapshot.hasData ||
                              _currentType == 'Produto' &&
                                  !offerSnapshot.hasData ||
                              offerSnapshot.data.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<OfferModel> _financialCredits =
                              offerSnapshot.data.offers;

                          return ListView.separated(
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: _currentType == 'Financeiro'
                                ? _financialCredits.length
                                : _productCredits.list.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 20,
                            ),
                            itemBuilder: (context, index) {
                              return _currentType == 'Financeiro'
                                  ? InkWell(
                                      onTap: () {
                                        _addCreditoFinanceiro(
                                            _financialCredits[index]);
                                      },
                                      child: CardWidget(
                                        parcels: _financialCredits[index]
                                            .installmentCount,
                                        value: _financialCredits[index].value,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _onTapSelectProduct(
                                            _productCredits.list[index]);
                                      },
                                      child: ProductWidget(
                                        credits:
                                            _productCredits.list[index].boxes,
                                        tests:
                                            _productCredits.list[index].tests,
                                        imageUrl: _productCredits
                                            .list[index].imageUrl,
                                        title:
                                            _productCredits.list[index].title,
                                      ));
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
                        onPressed: () {
                          _onTapPersonalizedValue(snapshot.data);
                        },
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
