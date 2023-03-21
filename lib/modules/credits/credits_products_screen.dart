// ignore_for_file: unused_field

import 'dart:async';
// import 'dart:developer';
// import 'dart:developer';
// import 'dart:html';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:random_string/random_string.dart';
// import 'package:rxdart/rxdart.dart';
import '../../blocs/product_bloc.dart';
import '../../models/product_model.dart';
import '../../repositories/product_repository.dart';

class CreditsProductScreen extends StatefulWidget {
  final ProductModel product;
  CreditsProductScreen({this.product});

  @override
  _CreditProductState createState() => _CreditProductState();
}

class _CreditProductState extends State<CreditsProductScreen> {
  HomeWidgetBloc _homeBloc = Modular.get<HomeWidgetBloc>();
  ProductBloc _productsBloc = Modular.get<ProductBloc>();
  CreditsBloc _creditsBloc = Modular.get<CreditsBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  TabController _tabController;
  AuthEvent _currentUser;
  MoneyMaskedTextController _creditProductValueController;
  bool _isLoadingPackage;
  Map<String, dynamic> _currentProduct;
  bool _loadingOffers = false;
  Offers _offersFinan = Offers(offers: []);
  Offers _offers;
  StreamSubscription _productReset;
  bool _lock = false;

  _onAddToCart(
      ProductModel product, int quantity, int value, int percentageTest) async {
    product.setValue(value);

    Map<String, dynamic> _data = {
      'value': value,
      '_cart_item': randomString(15),
      'quantity': quantity,
      'product': product,
      'percentage_test': percentageTest,
      'type': "C",
      'operation': "06"
    };
    int _total = _cartWidgetBloc.currentCartTotalItems;
    _cartWidgetBloc.cartTotalItemsSink.add(_total + 1);
    _requestsBloc.addProductToCart(_data);
  }

  _handleMyCredits() {
    _tabController.index = 1;
  }

  _onTapSelectCreditProduct(ProductModel product) async {
    setState(() {
      this._loadingOffers = true;
      _isLoadingPackage = true;
    });
    Offers _offers = await _creditsBloc.fetchCreditOfferSync(product.group);
    setState(() {
      _isLoadingPackage = false;
      this._loadingOffers = false;
      this._offers = _offers;
      this._currentProduct["selected"] = true;
      this._currentProduct["product"] = product;
    });
  }

  _addCreditoProduct(ProductModel product, OfferModel offer) {
    setState(() {
      _lock = true;
    });

    _onAddToCart(product, offer.quantity, offer.price, offer.percentageTest);
    _creditsBloc.offersSink
        .add(Offers(isEmpty: true, isLoading: false, type: "CREDIT"));
    setState(() {
      this._currentProduct["selected"] = false;
    });

    Modular.to.pushNamed("/credito_financeiro/cart");

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _lock = false;
      });
    });
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

  _onBackToPurchase() {
    _homeBloc.currentCreditTypeIn.add('Financeiro');
    _homeBloc.currentRequestTypeIn.add('Financeiro');
    _productsBloc.fetchOffers();
    Modular.to.pushNamed('/home/1');
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        content: Text('Voltar para a pagina anterior ?'),
        actions: [
          TextButton(
            child: Text(
              'Sim',
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 14),
            ),
            onPressed: _onBackToPurchase,
          ),
          SizedBox(width: 80),
          TextButton(
            child: Text(
              'Não',
              style:
                  Theme.of(context).textTheme.headline5.copyWith(fontSize: 14),
            ),
            onPressed: () => Navigator.pop(c, false),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }

  @override
  void initState() {
    _isLoadingPackage = false;
    _currentProduct = {"selected": false};
    if (widget.product != null) {
      _currentProduct['product'] = widget.product;
      _currentProduct['selected'] = true;
    }
    _productsBloc.fetchCreditProducts("Todos");
    _currentUser = _authBloc.getAuthCurrentUser;
    _creditsBloc.indexFinancialIn.add(_currentUser);
    _productReset = _creditsBloc.creditProductSelectedStream.listen((event) {
      if (!event) {
        _currentProduct = {"selected": false};
      }
    });

    _homeBloc.currentCreditTypeOut.listen((event) async {
      if (event == "Produto") {
        _creditsBloc.offersSink
            .add(Offers(isEmpty: true, type: "CREDIT", isLoading: false));
        _currentProduct = {"selected": false};
      } else {
        _currentProduct = {"selected": true};
        // setState(() {
        this._loadingOffers = true;
        // });

        _productsBloc.offersRedirectedSink.add(null);
        _productsBloc.productRedirectedSink.add(null);
      }
    });

    _onNavigate();
    _creditProductValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
    super.initState();
  }

  @override
  void dispose() {
    _productReset.cancel();
    _creditProductValueController.dispose();
    this._offers = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream: _productsBloc.creditProductListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData == true && snapshot.data == null) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("Carregando aguarde...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 16))
                          ])
                    ]);
              }
              if (_isLoadingPackage) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("Buscando pacotes...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 16))
                          ])
                    ]);
              }
              if (snapshot.data.isLoading) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text("Carregando aguarde...",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontSize: 16))
                          ])
                    ]);
              }
              List<ProductModel> _products = snapshot.data.list;
              return SafeArea(
                child: Column(
                  children: [
                    StreamBuilder<String>(
                      stream: _homeBloc.currentCreditTypeOut,
                      builder: (context, snapshot) {
                        String _currentType = snapshot.data;
                        if (_currentType != "Financeiro") {
                          return StreamBuilder(
                            stream: _productsBloc.productRedirectedStream,
                            builder: (context, prodRedirectSnapshot) {
                              ProductModel _currentProduct;
                              bool _selected;
                              if (prodRedirectSnapshot.hasData) {
                                _currentProduct = prodRedirectSnapshot.data;
                                _selected = true;
                              } else {
                                _currentProduct =
                                    this._currentProduct['product'];
                                _selected = this._currentProduct['selected'];
                              }
                              return StreamBuilder(
                                  stream: _productsBloc.creditProductListStream,
                                  builder: (context, snapshot2) {
                                    if (!snapshot2.hasData) {
                                      return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("Carregando aguarde...",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          .copyWith(
                                                              fontSize: 16))
                                                ])
                                          ]);
                                    }
                                    return StreamBuilder(
                                        stream: _productsBloc
                                            .offersRedirectedStream,
                                        builder: (context, offerSnapshot) {
                                          List<OfferModel> _financialCredits;

                                          if (offerSnapshot.hasData) {
                                            _financialCredits =
                                                offerSnapshot.data.offers;
                                          } else if (this._offers != null) {
                                            _financialCredits =
                                                this._offers?.offers ?? [];
                                          } else {
                                            _financialCredits =
                                                this._offersFinan.offers;
                                          }

                                          if (!snapshot.hasData) {
                                            return Container();
                                          } else if (_selected) {
                                            return Container(
                                              width: double.infinity,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _productsBloc
                                                                        .productRedirectedSink
                                                                        .add(
                                                                            null);
                                                                    _productsBloc
                                                                        .offersRedirectedSink
                                                                        .add(
                                                                            null);
                                                                    this._currentProduct[
                                                                            "selected"] =
                                                                        false;
                                                                  });
                                                                  _creditsBloc
                                                                      .offersSink
                                                                      .add(Offers(
                                                                          isEmpty:
                                                                              true,
                                                                          isLoading:
                                                                              false,
                                                                          type:
                                                                              "CREDIT"));
                                                                },
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .arrow_back,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 11,
                                                              child: Center(
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                25,
                                                                            bottom:
                                                                                25),
                                                                        child:
                                                                            Text(
                                                                          _currentProduct
                                                                              .title,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headline5
                                                                              .copyWith(color: Colors.black38, fontSize: 18),
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        _financialCredits
                                                                    .length >
                                                                0
                                                            ? Container(
                                                                width: double
                                                                    .infinity,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.87,
                                                                child: GridView
                                                                    .builder(
                                                                  itemCount:
                                                                      _financialCredits
                                                                          .length,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(12),
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                    mainAxisSpacing:
                                                                        15,
                                                                    crossAxisSpacing:
                                                                        20,
                                                                    childAspectRatio:
                                                                        0.7,
                                                                    mainAxisExtent:
                                                                        170,
                                                                  ),
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return InkWell(
                                                                      child:
                                                                          CreditProductCardWidget(
                                                                        precoUnitario:
                                                                            _financialCredits[index].price,
                                                                        caixas:
                                                                            _financialCredits[index].quantity,
                                                                        value: _financialCredits[index]
                                                                            .total,
                                                                        percentageTest:
                                                                            _financialCredits[index].percentageTest,
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        _addCreditoProduct(
                                                                            this._currentProduct["product"],
                                                                            _financialCredits[index]);
                                                                      },
                                                                    );
                                                                  },
                                                                ))
                                                            : Center(
                                                                heightFactor:
                                                                    40,
                                                                child: Text(
                                                                    'Não há pacotes para esse produto.'),
                                                              )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          ProductList _productCredits =
                                              snapshot2.data;
                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                color: Colors.white,
                                                margin: EdgeInsets.only(
                                                    top: 30, bottom: 30),
                                                child: Row(children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _onBackToPurchase();
                                                        });
                                                        _creditsBloc.offersSink
                                                            .add(Offers(
                                                                isEmpty: true,
                                                                isLoading:
                                                                    false,
                                                                type:
                                                                    "CREDIT"));
                                                      },
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.black,
                                                          size: 30,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 9,
                                                    child: Center(
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 0,
                                                                  bottom: 0),
                                                          child: Text(
                                                            "Selecione o Produto",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5,
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 40,
                                                  ),
                                                ]),
                                              ),
                                              _products.length > 0
                                                  ? Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.799,
                                                      child: GridView.builder(
                                                        itemCount:
                                                            _products.length,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          mainAxisExtent: 168,
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 5,
                                                          crossAxisSpacing: 10,
                                                          childAspectRatio: 0.7,
                                                        ),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              // setState(() {
                                                              //   _isLoadingPackage =
                                                              //       true;
                                                              // });
                                                              Helper.whenDifferentOperation(
                                                                  '06', () {
                                                                _onTapSelectCreditProduct(
                                                                    _productCredits
                                                                            .list[
                                                                        index]);
                                                              },
                                                                  context,
                                                                  _requestsBloc
                                                                      .cartItems,
                                                                  _requestsBloc,
                                                                  _cartWidgetBloc);
                                                            },
                                                            child:
                                                                ProductWidget(
                                                              credits:
                                                                  _productCredits
                                                                      .list[
                                                                          index]
                                                                      .boxes,
                                                              tests:
                                                                  _productCredits
                                                                      .list[
                                                                          index]
                                                                      .tests,
                                                              imageUrl:
                                                                  _productCredits
                                                                      .list[
                                                                          index]
                                                                      .imageUrl,
                                                              title:
                                                                  _productCredits
                                                                      .list[
                                                                          index]
                                                                      .title,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Center(
                                                      heightFactor: 40,
                                                      child: Text(
                                                          "Não há produtos disponíveis no momento"),
                                                    )
                                            ],
                                          );
                                        });
                                  });
                            },
                          );
                        }
                        return ListTileMoreCustomizable(
                          contentPadding: const EdgeInsets.all(0),
                          horizontalTitleGap: -5,
                          leading: Text(
                            snapshot.data == 'Financeiro' ? '' : 'Cx',
                            style:
                                Theme.of(context).textTheme.subtitle2.copyWith(
                                      fontSize: 18,
                                      color: Colors.white54,
                                    ),
                          ),
                          title: StreamBuilder(
                            stream: _creditsBloc.currentProductStream,
                            builder: (context, snapshot2) {
                              if (snapshot.data != 'Financeiro' &&
                                  !snapshot2.hasData) {
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                  return Row(
                                    // aqui
                                    children: [
                                      Text(
                                        snapshot.data == 'Financeiro'
                                            ? ''
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
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        onWillPop: _onWillPop);
  }
}
