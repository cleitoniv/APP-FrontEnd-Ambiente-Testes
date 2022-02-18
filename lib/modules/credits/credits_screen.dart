import 'dart:async';
import 'dart:convert';
import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credit_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/auth_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:random_string/random_string.dart';

class CreditsScreen extends StatefulWidget {
  final ProductModel product;
  CreditsScreen({this.product});

  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  HomeWidgetBloc _homeBloc = Modular.get<HomeWidgetBloc>();
  bool _isLoadingPackage;
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

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

  Offers _offers;
  Offers _offersFinan = Offers(offers: []);

  bool _loadingOffers = false;

  bool _lock = false;

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

  _addCreditoProduct(ProductModel product, OfferModel offer) {
    setState(() {
      _lock = true;
    });

    _onAddToCart(product, offer.quantity, offer.price,
        offer.percentageTest);
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

  _onTapPersonalizedValue(String type) {
    // _homeBloc.valueVisibilityIn.add(true);
    if (type == "Financeiro") {
      Modular.to.pushNamed('/credito_financeiro');
    } else {
      Modular.to.pushNamed('/credito_financeiro/produto');
    }
  }

  _onTapSelectCreditProduct(ProductModel product) async {
    //_creditsBloc.fetchCreditOffers(product.group);
    setState(() {
      this._loadingOffers = true;
    });

    Offers _offers = await _creditsBloc.fetchCreditOfferSync(product.group);

    setState(() {
      this._loadingOffers = false;
      this._offers = _offers;
      this._currentProduct["selected"] = true;
      this._currentProduct["product"] = product;
    });
  }

  void _addCreditoFinanceiro(OfferModel offer) {
    _creditoFinanceiroBloc.creditoFinaceiroSink.add(CreditoFinanceiro(
        valor: offer.value,
        installmentCount: offer.installmentCount,
        desconto: offer.discount));
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

  _otherValue() {
    return StreamBuilder<String>(
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
                // return RaisedButton(
                //   elevation: 0,
                //   onPressed: () {
                //     _onTapPersonalizedValue(snapshot.data);
                //   },
                //   child: Text(
                //     snapshot.data == 'Financeiro'
                //         ? 'Valor Personalizado'
                //         : 'Comprar Crédito de Produto',
                //     style: Theme.of(context).textTheme.button,
                //   ),
                // );
                return InkWell(
                  onTap: () {
                    _onTapPersonalizedValue(snapshot.data);
                  },
                  child: CardWidgetOtherValue(),
                );
              } else {
                return Container();
              }
            }
          },
        );
      },
    );
  }

  _getCreditType() async {
    if(await _homeBloc.currentCreditTypeOut.isEmpty) {
      _homeBloc.currentCreditTypeIn.add('Financeiro');
    }
  }


  @override
  void initState() {
    _isLoadingPackage = false;
    _currentProduct = {"selected": false};
    print("widget product");
    print(widget.product);
    if(widget.product != null) {
      _currentProduct['product'] = widget.product;
      _currentProduct['selected'] = true;
    }
    print("1");
    _productsBloc.fetchCreditProducts("Todos");
    _currentUser = _authBloc.getAuthCurrentUser;
    print("2");
    _creditsBloc.indexFinancialIn.add(_currentUser);
    _productReset = _creditsBloc.creditProductSelectedStream.listen((event) {
      if (!event) {
        _currentProduct = {"selected": false};
      }
    });
    print("3");

    _homeBloc.currentCreditTypeOut.listen((event) async {
      if (event == "Produto") {
        _creditsBloc.offersSink
            .add(Offers(isEmpty: true, type: "CREDIT", isLoading: false));
//        _productsBloc.offersRedirectedSink.add(null);
//        _productsBloc.productRedirectedSink.add(null);
        _currentProduct = {"selected": false};
      } else {
        _currentProduct = {"selected": true};
        print("printing....");
        setState(() {
          this._loadingOffers = true;
        });

        _productsBloc.offersRedirectedSink.add(null);
        _productsBloc.productRedirectedSink.add(null);

        Offers of = await _creditsBloc.fetchOffersSync();

        setState(() {
          this._offers = of;
          this._loadingOffers = false;
        });
      }
    });
    print("4");

    _onNavigate();
    _creditValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
    print("5");
    super.initState();
  }

  @override
  void dispose() {
    _productReset.cancel();
    _creditValueController.dispose();
    this._offers = null;
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
                    stream: _productsBloc.productRedirectedStream,
                    builder: (context, prodRedirectSnapshot) {
                      ProductModel _currentProduct;
                      bool _selected;
                      if(prodRedirectSnapshot.hasData) {
                        _currentProduct = prodRedirectSnapshot.data;
                        _selected = true;
                      } else {
                        _currentProduct = this._currentProduct['product'];
                        _selected = this._currentProduct['selected'];
                      }
                      print("selected---");
                      print(_selected);
                      return StreamBuilder(
                          stream: _productsBloc.creditProductListStream,
                          builder: (context, snapshot) {
                            print("products");
                            print(snapshot.data);
                            if (!snapshot.hasData) {
                              return Container();
                            } else if (snapshot.data.isLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (_selected) {
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
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 11,
                                                child: Center(
                                                  child: Container(
                                                      margin: EdgeInsets.only(top: 25, bottom: 25),
                                                      child: Text(
                                                        _currentProduct.title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                            color: Colors.black38,
                                                            fontSize: 18),
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _productsBloc.productRedirectedSink.add(null);
                                                      _productsBloc.offersRedirectedSink.add(null);
                                                      this._currentProduct["selected"] = false;
                                                    });
                                                    _creditsBloc.offersSink.add(Offers(
                                                        isEmpty: true,
                                                        isLoading: false,
                                                        type: "CREDIT"));
                                                  },
                                                  child: Center(
                                                    child: Icon(Icons.cancel, color: Colors.red, size: 40,),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          ProductWidget(
                                            credits: _currentProduct
                                                .boxes,
                                            tests: _currentProduct
                                                .tests,
                                            imageUrl: _currentProduct
                                                .imageUrl,
                                            title: "",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            print("snapshot");
                            print(snapshot.data.toString());
                            ProductList _productCredits = snapshot.data;
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 30, bottom: 30),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      "Selecione o Produto",
                                      // textScaleFactor: 1.25,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                Container(
                                    width: double.infinity,
                                    height: 300,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _productCredits.list.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            width: 20,
                                          ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () async {
                                              _onTapSelectCreditProduct(
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
                                    ))
                              ],
                            );
                          });
                    },
                  );
                }
                return ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: -5,
                  leading: Text(
                    snapshot.data == 'Financeiro' ? '' : 'Cx',
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
          ),
          // mover
          StreamBuilder(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, headerSnapshot) {
                if (!headerSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                String _headerCurrentType = headerSnapshot.data;
                return Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: MediaQuery.of(context).size.height /
                      (_headerCurrentType == "Financeiro"
                          ? 1.66
                          : _currentProduct["selected"] == true
                              ? 3.3
                              : 4.0),
                  child: Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 20),
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

                            return StreamBuilder(
                              builder: (context, offSnapshot) {
                                return StreamBuilder(
                                  stream: _productsBloc.offersRedirectedStream,
                                  builder: (context, offerSnapshot) {
                                    if (this._loadingOffers) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (!_currentProduct["selected"] && !offerSnapshot.hasData) {
                                      return Center(
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                                "Selecione um produto para ver as ofertas."),
                                          ));
                                    }
                                    List<OfferModel> _financialCredits;

                                    if(offerSnapshot.hasData) {
                                      _financialCredits = offerSnapshot.data.offers;
                                    } else  if(this._offers != null){
                                      _financialCredits =
                                          this._offers?.offers ?? [];
                                    } else {
                                      _financialCredits = this._offersFinan.offers;
                                    }

                                    print("financial credits");

                                    return Column(
                                      children: [
                                        _currentType != 'Financeiro'
                                            ? Expanded(
                                          flex: 10,
                                          child: Container(
                                              height: 200,
                                              child: !_isLoadingPackage
                                                  ? _financialCredits.length >
                                                  0
                                                  ? ListView.separated(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 20,
                                                    right: 20),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                _currentType ==
                                                    'Financeiro'
                                                    ? Axis
                                                    .vertical
                                                    : Axis
                                                    .horizontal,
                                                itemCount: _currentType ==
                                                    'Financeiro'
                                                    ? _financialCredits
                                                    .length +
                                                    1
                                                    : _financialCredits
                                                    .length,
                                                separatorBuilder:
                                                    (context,
                                                    index) {
                                                  if (index == 0 &&
                                                      _currentType ==
                                                          'Financeiro') {
                                                    return SizedBox(
                                                      height: 15,
                                                    );
                                                  }
                                                  if (_currentType ==
                                                      'Financeiro') {
                                                    return SizedBox(
                                                      height: 5,
                                                    );
                                                  } else {
                                                    return SizedBox(
                                                      width: 20,
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (context,
                                                    index) {
                                                  if (index == 0 &&
                                                      _currentType ==
                                                          'Financeiro') {
                                                    return Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        FittedBox(
                                                          fit: BoxFit
                                                              .contain,
                                                          child:
                                                          Text(
                                                            "Selecione o Pacote",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .headline5,
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  }

                                                  if (_currentType ==
                                                      'Financeiro') {
                                                    index -= 1;
                                                  }

                                                  return _currentType ==
                                                      'Financeiro'
                                                      ? InkWell(
                                                    onTap:
                                                        () {
                                                      print("aqui B");
                                                      setState(
                                                              () {
                                                            _isLoadingPackage =
                                                            true;
                                                          });
                                                      _addCreditoFinanceiro(
                                                          _financialCredits[index]);
                                                      setState(
                                                              () {
                                                            _isLoadingPackage =
                                                            false;
                                                          });
                                                    },
                                                    child:
                                                    CardWidget(
                                                      parcels:
                                                      _financialCredits[index].installmentCount,
                                                      value: _financialCredits[index]
                                                          .value,
                                                      discount:
                                                      _financialCredits[index].discount,
                                                    ),
                                                  )
                                                      : StreamBuilder(
                                                    stream: _productsBloc.productRedirectedStream,
                                                    builder: (context, productSnapshot) {
                                                      return InkWell(
                                                          onTap:
                                                              () {
                                                            print("aqui A");
//                                                                        bool
//                                                                            blocked =
//                                                                            await _authBloc.checkBlockedUser(context);
//                                                                        if (!blocked &&
//                                                                            !_lock) {
//
//                                                                        }
                                                            _addCreditoProduct(
                                                                productSnapshot.data ?? this._currentProduct["product"],
                                                                _financialCredits[index]);
                                                          },
                                                          child: CreditProductCardWidget(
                                                              precoUnitario: _financialCredits[index]
                                                                  .price,
                                                              caixas: _financialCredits[index]
                                                                  .quantity,
                                                              value: _financialCredits[index]
                                                                  .total,
                                                              percentageTest:
                                                              _financialCredits[index].percentageTest));
                                                    },
                                                  );
                                                },
                                              )
                                                  : Center(
                                                child: Container(
                                                  child: Text(
                                                      "Não há pacotes para esse produto."),
                                                ),
                                              )
                                                  : Center(
                                                  child:
                                                  CircularProgressIndicator())),
                                        )
                                            : Expanded(
                                          flex: 10,
                                          child: Container(
                                              height: 200,
                                              child: !_isLoadingPackage
                                                  ? _financialCredits.length >
                                                  0
                                                  ? Column(
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit
                                                        .contain,
                                                    child: Text(
                                                      "Selecione o Pacote",
                                                      style: Theme.of(
                                                          context)
                                                          .textTheme
                                                          .headline5,
                                                    ),
                                                  ),
                                                  GridView.builder(
                                                    gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                        2),
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left:
                                                        20,
                                                        right:
                                                        20),
                                                    shrinkWrap:
                                                    true,
                                                    scrollDirection:
                                                    _currentType ==
                                                        'Financeiro'
                                                        ? Axis
                                                        .vertical
                                                        : Axis
                                                        .horizontal,
                                                    itemCount: _currentType ==
                                                        'Financeiro'
                                                        ? _financialCredits
                                                        .length +
                                                        1
                                                        : _financialCredits
                                                        .length,
                                                    itemBuilder:
                                                        (context,
                                                        index) {
                                                      if (index >=
                                                          _financialCredits
                                                              .length) {
                                                        return _otherValue();
                                                      }
                                                      return _currentType ==
                                                          'Financeiro'
                                                          ? InkWell(
                                                        onTap:
                                                            () async {
                                                          setState(() {
                                                            _isLoadingPackage = true;
                                                          });
                                                          _addCreditoFinanceiro(_financialCredits[index]);
                                                          setState(() {
                                                            _isLoadingPackage = false;
                                                          });
                                                        },
                                                        child:
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(5),
                                                          child:
                                                          CardWidget(
                                                            parcels: _financialCredits[index].installmentCount,
                                                            value: _financialCredits[index].value,
                                                            discount: _financialCredits[index].discount,
                                                          ),
                                                        ),
                                                      )
                                                          : InkWell(

                                                        onTap:
                                                            () async {
                                                          print("OLA");
                                                          _addCreditoProduct(this._currentProduct["product"], _financialCredits[index]);
                                                        },
                                                        child:
                                                        CreditProductCardWidget(
                                                          precoUnitario:
                                                          _financialCredits[index].price,
                                                          caixas:
                                                          _financialCredits[index].quantity,
                                                          value:
                                                          _financialCredits[index].total,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              )
                                                  : Center(
                                                child: Container(
                                                  child: Text(
                                                      "Não há pacotes para esse produto."),
                                                ),
                                              )
                                                  : Center(
                                                  child:
                                                  CircularProgressIndicator())),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
