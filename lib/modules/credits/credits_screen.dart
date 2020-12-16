import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/financial_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/product_credit_model.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:random_string/random_string.dart';

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

  Map<String, dynamic> _currentProduct;

  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();

  StreamSubscription _productReset;

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

  _onAddToCart(ProductModel product, int quantity, int value) async {
    product.setValue(value);

    Map<String, dynamic> _data = {
      '_cart_item': randomString(15),
      'quantity': quantity,
      'product': product,
      'type': "C",
      'operation': "06"
    };
    _requestsBloc.addProductToCart(_data);
    // print(_data);
  }

  _addCreditoProduct(OfferModel offer) {
    _onAddToCart(this._currentProduct["product"], offer.quantity, offer.price);
    _creditsBloc.offersSink
        .add(Offers(isEmpty: true, isLoading: false, type: "CREDIT"));
    setState(() {
      this._currentProduct["selected"] = false;
    });
    Modular.to.pushNamed("/credito_financeiro/cart");
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

  _onTapSelectCreditProduct(ProductModel product) {
    setState(() {
      this._currentProduct["selected"] = true;
      this._currentProduct["product"] = product;
    });
    _creditsBloc.fetchCreditOffers(product.group);
  }

  void _addCreditoFinanceiro(OfferModel offer) {
    _creditoFinanceiroBloc.creditoFinaceiroSink.add(CreditoFinanceiro(
        valor: offer.value,
        installmentCount: offer.installmentCount,
        desconto: 0));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  _onNavigate() async {
    String _currentType = await _homeBloc.currentCreditType;
    if (_currentType == "Produto") {
      _creditsBloc.offersSink
          .add(Offers(isEmpty: true, type: "CREDIT", isLoading: false));
    } else {
      _creditsBloc.fetchOffers();
    }
  }

  @override
  void initState() {
    super.initState();
    _currentProduct = {"selected": false};
    _productsBloc.fetchCreditProducts("Todos");
    _currentUser = _authBloc.getAuthCurrentUser;
    _creditsBloc.indexFinancialIn.add(_currentUser);
    _productReset = _creditsBloc.creditProductSelectedStream.listen((event) {
      if (!event) {
        _currentProduct = {"selected": false};
      }
    });
    _onNavigate();
    _creditValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
  }

  @override
  void dispose() {
    _productReset.cancel();
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
                String _currentType = snapshot.data;
                if (_currentType != "Financeiro") {
                  return StreamBuilder(
                      stream: _productsBloc.creditProductListStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.data.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (this._currentProduct["selected"]) {
                          return Container(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        this._currentProduct["product"].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                                color: Colors.black38,
                                                fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ProductWidget(
                                        credits: this
                                            ._currentProduct["product"]
                                            .boxes,
                                        tests: this
                                            ._currentProduct["product"]
                                            .tests,
                                        imageUrl: this
                                            ._currentProduct["product"]
                                            .imageUrl,
                                        title: "",
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(right: 40),
                                  height:
                                      MediaQuery.of(context).size.height / 4.3,
                                  child: Align(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          this._currentProduct["selected"] =
                                              false;
                                        });
                                        _creditsBloc.offersSink.add(Offers(
                                            isEmpty: true,
                                            isLoading: false,
                                            type: "CREDIT"));
                                      },
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        child: Text(
                                          "Voltar",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.bottomRight,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        ProductList _productCredits = snapshot.data;
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Selecione o Produto",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Container(
                                width: double.infinity,
                                height: 300,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(20),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _productCredits.list.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () async {
                                          bool blocked = await _authBloc
                                              .checkBlockedUser(context);
                                          if (!blocked) {
                                            _onTapSelectCreditProduct(
                                                _productCredits.list[index]);
                                          }
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
                                ))
                          ],
                        );
                      });
                }
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
                        stream: _authBloc.clienteDataStream,
                        builder: (context, snapshot3) {
                          if (snapshot.data == 'Financeiro' &&
                                  !snapshot3.hasData ||
                              snapshot3.data.loading) {
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
          StreamBuilder(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, headerSnapshot) {
                String _headerCurrentType = headerSnapshot.data;
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: MediaQuery.of(context).size.height /
                      (_headerCurrentType == "Financeiro" ? 2.2 : 3.0),
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
                                } else if (offerSnapshot.hasData &&
                                    offerSnapshot.data.isEmpty &&
                                    offerSnapshot.data.type == "CREDIT") {
                                  return Center(
                                      child: Text(
                                          "Selecione um produto para ver as ofertas"));
                                }
                                List<OfferModel> _financialCredits =
                                    offerSnapshot.data.offers;

                                return Column(
                                  children: [
                                    Text(
                                      "Selecione o Pacote",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    Container(
                                      height: 200,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(20),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _currentType == 'Financeiro'
                                            ? _financialCredits.length
                                            : _financialCredits.length,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                          width: 20,
                                        ),
                                        itemBuilder: (context, index) {
                                          return _currentType == 'Financeiro'
                                              ? InkWell(
                                                  onTap: () async {
                                                    bool blocked =
                                                        await _authBloc
                                                            .checkBlockedUser(
                                                                context);
                                                    if (!blocked) {
                                                      _addCreditoFinanceiro(
                                                          _financialCredits[
                                                              index]);
                                                    }
                                                  },
                                                  child: CardWidget(
                                                    parcels:
                                                        _financialCredits[index]
                                                            .installmentCount,
                                                    value:
                                                        _financialCredits[index]
                                                            .value,
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    bool blocked =
                                                        await _authBloc
                                                            .checkBlockedUser(
                                                                context);
                                                    if (!blocked) {
                                                      _addCreditoProduct(
                                                          _financialCredits[
                                                              index]);
                                                    }
                                                  },
                                                  child:
                                                      CreditProductCardWidget(
                                                    precoUnitario:
                                                        _financialCredits[index]
                                                            .price,
                                                    caixas:
                                                        _financialCredits[index]
                                                            .quantity,
                                                    value:
                                                        _financialCredits[index]
                                                            .total,
                                                  ),
                                                );
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: StreamBuilder<String>(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, snapshot) {
                String _currentType = snapshot.data;
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
                      if (_currentType == "Financeiro") {
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
                      } else {
                        return Container();
                      }
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
