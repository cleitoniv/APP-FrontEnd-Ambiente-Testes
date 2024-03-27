import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CardWidget extends StatelessWidget {
  final int value;
  final int parcels;
  final int discount;

  CardWidget({
    this.value = 20000,
    this.parcels = 1,
    this.discount = 5,
  });

  _verifyTextScaleFactor(double size) {
    if (size < 1.5) {
      return 170.0;
    } else {
      return 200.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          width: 190,
          height:
              _verifyTextScaleFactor(MediaQuery.of(context).textScaleFactor),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xffF1F1F1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.contain,
                child: Text.rich(
                  TextSpan(
                    text: 'R\$ ',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                        ),
                    children: [
                      TextSpan(
                        text: Helper.intToMoney(value),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'De créditos',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                ),
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "$discount% de Desconto",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 14,
                      ),
                ),
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  parcels == 1 || parcels == 0 ? 'À vista' : 'Até ${parcels}x',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 170,
          width: 180,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              MaterialCommunityIcons.plus_circle,
              color: Theme.of(context).primaryColor,
              size: 50,
            ),
          ),
        )
      ],
    );
  }
}

class CardWidgetOtherValue extends StatelessWidget {
  CardWidgetOtherValue();

  _verifyTextScaleFactor(double size) {
    if (size < 1.5) {
      return 170.0;
    } else {
      return 200.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 190,
            height:
                _verifyTextScaleFactor(MediaQuery.of(context).textScaleFactor),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).accentColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.attach_money,
                  size: 60,
                  color: Colors.white,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Outro valor",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class CreditProductCardWidget extends StatelessWidget {
  final int value;
  final int parcels;
  final int caixas;
  final int precoUnitario;
  final int percentageTest;

  CreditProductCardWidget({
    this.precoUnitario = 20000,
    this.value = 20000,
    this.parcels = 1,
    this.percentageTest,
    this.caixas = 20,
  });

  _verifyTextScaleFactor(double size) {
    if (size < 1.5) {
      return 190.0;
    } else {
      return 220.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
            fit: StackFit.loose,
            clipBehavior: Clip.none,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    width: 180,
                    height: _verifyTextScaleFactor(
                        MediaQuery.of(context).textScaleFactor),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xffF1F1F1),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text.rich(
                              TextSpan(
                                text: "${this.caixas}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 40),
                                children: [
                                  TextSpan(
                                    text: ' Caixas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.black45,
                                            fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "R\$ ${Helper.intToMoney(this.precoUnitario)} por caixa.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Até ${this.percentageTest ?? 0}% de teste",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Por ${Helper.intToMoney(this.value)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Theme.of(context).accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Icon(
                      MaterialCommunityIcons.plus_circle,
                      color: Theme.of(context).primaryColor,
                      size: 42,
                    ),
                  )
                ],
              ),
            ],
          );
  }
}

class CreditProductOtherWidget extends StatelessWidget {
  final int value;
  final int parcels;
  final int caixas;
  final int precoUnitario;
  final int percentageTest;

  CreditProductOtherWidget({
    this.precoUnitario = 0,
    this.value = 0,
    this.parcels = 0,
    this.percentageTest = 0,
    this.caixas = 0,
  });
  

  _verifyTextScaleFactor(double size) {
    if (size < 1.5) {
      return 190.0;
    } else {
      return 220.0;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 190,
            height:
                _verifyTextScaleFactor(MediaQuery.of(context).textScaleFactor),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).accentColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon(
                //   Icons.plus_one,
                //   size: 60,
                //   color: Colors.white,
                // ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    "Pacote Personalizado",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    softWrap: true,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
