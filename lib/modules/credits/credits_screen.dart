import 'dart:async';
import 'dart:developer';
// import 'dart:convert';
// import 'dart:developer';
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
import 'package:rxdart/rxdart.dart';

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

  _onTapPersonalizedValue(String type) {
    // _homeBloc.valueVisibilityIn.add(true);
    if (type == "Financeiro") {
      Modular.to.pushNamed('/credito_financeiro');
    } else {
      Modular.to.pushNamed('/credito_financeiro/produto');
    }
  }

  // _onTapSelectCreditProduct(ProductModel product) async {
  //   //_creditsBloc.fetchCreditOffers(product.group);
  //   setState(() {
  //     this._loadingOffers = true;
  //   });

  //   Offers _offers = await _creditsBloc.fetchCreditOfferSync(product.group);
  //   setState(() {
  //     this._loadingOffers = false;
  //     this._offers = _offers;
  //     this._currentProduct["selected"] = true;
  //     this._currentProduct["product"] = product;
  //   });
  // }

  void _addCreditoFinanceiro(OfferModel offer) {
    _creditoFinanceiroBloc.creditoFinaceiroSink.add(CreditoFinanceiro(
        valor: offer.value,
        installmentCount: offer.installmentCount,
        desconto: offer.discount));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  _onNavigate() async {
    String _currentType = await _homeBloc.currentCreditType;
    print('esse botão');
    if (_currentType == "Produto") {
      _creditsBloc.offersSink
          .add(Offers(isEmpty: true, type: "CREDIT", isLoading: true));
    } else {
      _productsBloc.fetchOffers();
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
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
                // return ElevatedButton(
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
                    print('linha 207');
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
    if (await _homeBloc.currentCreditTypeOut.isEmpty) {
      _homeBloc.currentCreditTypeIn.add('Financeiro');
    }
  }

  @override
  void initState() {
    _productsBloc.fetchCreditProducts("Todos");
    // _productsBloc.fetchOffers();
    
    // _productsBloc.fetchOffers();
    _isLoadingPackage = false;
    _currentProduct = {"selected": false};
    if (widget.product != null) {
      _currentProduct['product'] = widget.product;
      _currentProduct['selected'] = true;
    }
    print('linha 235');
    
    
    _currentUser = _authBloc.getAuthCurrentUser;
    _creditsBloc.indexFinancialIn.add(_currentUser);
    _productReset = _creditsBloc.creditProductSelectedStream.listen((event) {
      if (!event) {
        _currentProduct = {"selected": false};
        // _productsBloc.fetchOffers();
      }
    });

    _homeBloc.currentCreditTypeOut.listen((event) async {
      if (event == "Produto") {
        _creditsBloc.offersSink
            .add(Offers(isEmpty: true, type: "CREDIT", isLoading: false));
        _currentProduct = {"selected": false};
      } else {
        _currentProduct = {"selected": true};

        print('passando linha 258');
        // Offers of = await _creditsBloc.fetchOffersSync();
        // this._offers = of;
        // setState(() {
        // this._loadingOffers = false;
        // });

        // _productsBloc.offersRedirectedSink.add(null);
        // _productsBloc.productRedirectedSink.add(null);

        // Offers of = await _creditsBloc.fetchOffersSync();

        // setState(() {
        // this._offers = of;
        // this._loadingOffers = false;
        // });
      }
    });

    _onNavigate();
    _creditValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
    super.initState();
  }

  @override
  void dispose() {
    _productReset.cancel();
    _creditValueController.dispose();
    // _productsBloc.offersRedirectedSink.close();
    // _productsBloc.offersRedirectedStream.doOnCancel(() => null);
    // this._offers = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        clipBehavior: Clip.hardEdge,
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
                      if (prodRedirectSnapshot.hasData) {
                        _currentProduct = prodRedirectSnapshot.data;
                        _selected = true;
                      } else {
                        _currentProduct = this._currentProduct['product'];
                        _selected = this._currentProduct['selected'];
                      }
                      // return StreamBuilder(
                      //     stream: _productsBloc.creditProductListStream,
                      //     builder: (context, snapshot) {

                            // if (!snapshot.hasData) {
                            //   return Container();
                            // }
                             // else if (snapshot.data.isLoading) {
                            //   return Center(child: CircularProgressIndicator());
                            // } 
                             if (_selected) {
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
                                                      margin: EdgeInsets.only(
                                                          top: 25, bottom: 25),
                                                      child: Text(
                                                        _currentProduct.title,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                color: Colors
                                                                    .black38,
                                                                fontSize: 18),
                                                      )),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    // setState(() {
                                                    //   _productsBloc
                                                    //       .productRedirectedSink
                                                    //       .add(null);
                                                    //   _productsBloc
                                                    //       .offersRedirectedSink
                                                    //       .add(null);
                                                    //   this._currentProduct[
                                                    //       "selected"] = false;
                                                    // });
                                                    _creditsBloc.offersSink.add(
                                                        Offers(
                                                            isEmpty: true,
                                                            isLoading: false,
                                                            type: "CREDIT"));
                                                  },
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 40,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          ProductWidget(
                                            credits: _currentProduct.boxes,
                                            tests: _currentProduct.tests,
                                            imageUrl: _currentProduct.imageUrl,
                                            title: "",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: [
                                // Container(
                                //   margin: EdgeInsets.only(top: 30, bottom: 30),
                                //   child: FittedBox(
                                //     fit: BoxFit.contain,
                                //     child: Text(
                                //       "Selecione o Produto",
                                //       // textScaleFactor: 1.25,
                                //       overflow: TextOverflow.ellipsis,
                                //       maxLines: 1,
                                //       style:
                                //           Theme.of(context).textTheme.headline5,
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //     width: double.infinity,
                                //     height: 300,
                                //     child: ListView.separated(
                                //       scrollDirection: Axis.horizontal,
                                //       itemCount: _productCredits.list.length,
                                //       separatorBuilder: (context, index) =>
                                //           SizedBox(
                                //         width: 20,
                                //       ),
                                //       itemBuilder: (context, index) {
                                //         return GestureDetector(
                                //             onTap: () async {
                                //               print('linha 426');
                                //               _onTapSelectCreditProduct(
                                //                   _productCredits.list[index]);
                                //             },
                                //             child: ProductWidget(
                                //               credits: _productCredits
                                //                   .list[index].boxes,
                                //               tests: _productCredits
                                //                   .list[index].tests,
                                //               imageUrl: _productCredits
                                //                   .list[index].imageUrl,
                                //               title: _productCredits
                                //                   .list[index].title,
                                //             ));
                                //       },
                                //     ))
                              ],
                            );
                          // });
                    },
                  );
                }
                return ListTileMoreCustomizable(
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: -5,
                  leading: Text(
                    _currentType == 'Financeiro' ? '' : 'Cx',
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
                                stream: _productsBloc.offersRedirectedStream,
                                builder: (context, offerSnapshot) {
                                  // inspect(offerSnapshot);
                                  if (offerSnapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  List<OfferModel> _financialCredits;
                                  _financialCredits =
                                        offerSnapshot.data.offers ?? [];
                                  // if (this._loadingOffers) {



                                  //   if (_financialCredits != null) {
                                  //   return Center(
                                  //     child: CircularProgressIndicator(),
                                  //   );
                                  // } else if (!_currentProduct["selected"] &&
                                  //     !offerSnapshot.hasData) {
                                  //   return Center(
                                  //       child: FittedBox(
                                  //     fit: BoxFit.contain,
                                  //     child: Text(" "),
                                  //   ));
                                  // }



                                  // if (offerSnapshot.data == null && _financialCredits == null) {
                                  //   _productsBloc.fetchOffers();
                                  // }
                                  print('linha 601');
                                  print(offerSnapshot.data);
                                  // // inspect(offerSnapshot.data);
                                  // aqui 
                                  // if (offerSnapshot.hasData && _financialCredits == null) {
                                  //   print('entrada 1');
                                    // _financialCredits =
                                    //     offerSnapshot.data.offers ?? [];
                                  // } 
                                  // aqui ^ 
                                  // else if (this._offers != null) {
                                  //   print('entrada 2');
                                  //   _financialCredits =
                                  //       this._offers?.offers ?? [];
                                  //   print(_financialCredits);
                                  //   print('result entrada 2');
                                  // } 




                                  // else {
                                  //   print('entrada 3');
                                  //   _financialCredits =
                                  //       this._offersFinan.offers;
                                  // }

                                  return Column(
                                    children: [
                                      _currentType != 'Financeiro'
                                          ? Expanded(
                                              flex: 10,
                                              child: Container(
                                                  height: 200,
                                                  child: !_isLoadingPackage
                                                      ? _financialCredits
                                                                  .length >
                                                              0
                                                          ? ListView.separated(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
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
                                                                if (index ==
                                                                        0 &&
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
                                                                if (index ==
                                                                        0 &&
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
                                                                          setState(
                                                                              () {
                                                                            _isLoadingPackage =
                                                                                true;
                                                                          });
                                                                          _addCreditoFinanceiro(
                                                                              _financialCredits[index]);
                                                                        },
                                                                        child:
                                                                        Container()
                                                                        //     CardWidget(
                                                                        //   parcels:
                                                                        //       _financialCredits[index].installmentCount,
                                                                        //   value:
                                                                        //       _financialCredits[index].value,
                                                                        //   discount:
                                                                        //       _financialCredits[index].discount,
                                                                        // ),
                                                                      )
                                                                    : InkWell(
                                                                              onTap: () {
//                                                                        bool
//                                                                            blocked =
//                                                                            await _authBloc.checkBlockedUser(context);
//                                                                        if (!blocked &&
//                                                                            !_lock) {
//
//                                                                        }
                                                                                Helper.whenDifferentOperation('06', () {
                                                                                  _addCreditoProduct(productSnapshot.data ?? this._currentProduct["product"], _financialCredits[index]);
                                                                                }, context, _requestsBloc.cartItems, _requestsBloc, _cartWidgetBloc);
                                                                              },
                                                                              child: CreditProductCardWidget(precoUnitario: _financialCredits[index].price, caixas: _financialCredits[index].quantity, value: _financialCredits[index].total, percentageTest: _financialCredits[index].percentageTest),
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
                                                      ? _financialCredits !=
                                                              null
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
                                                                GridView
                                                                    .builder(
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount:
                                                                              2),
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection: _currentType ==
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
                                                                              Helper.whenDifferentOperation(
                                                                              '13', () {
                                                                            _addCreditoFinanceiro(_financialCredits[index]);
                                                                              setState(() {
                                                                                _isLoadingPackage = false;
                                                                              });
                                                                          },
                                                                              context,
                                                                              _requestsBloc
                                                                                  .cartItems,
                                                                              _requestsBloc,
                                                                              _cartWidgetBloc);
                                                                              
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.all(5),
                                                                              child: CardWidget(
                                                                                parcels: _financialCredits[index].installmentCount,
                                                                                value: _financialCredits[index].value,
                                                                                discount: _financialCredits[index].discount,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              _addCreditoProduct(this._currentProduct["product"], _financialCredits[index]);
                                                                            },
                                                                            child:
                                                                                CreditProductCardWidget(
                                                                              precoUnitario: _financialCredits[index].price,
                                                                              caixas: _financialCredits[index].quantity,
                                                                              value: _financialCredits[index].total,
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
