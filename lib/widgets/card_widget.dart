import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sizer/sizer.dart';

class CardWidget extends StatelessWidget {
  int value;
  int parcels;
  int discount;

  CardWidget({this.value = 20000, this.parcels = 1, this.discount = 5});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          width: 190,
          height: 170,
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
                  "${discount}% de Desconto",
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 190,
            height: 170,
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
  int value;
  int parcels;
  int caixas;
  int precoUnitario;
  int percentageTest;

  CreditProductCardWidget(
      {this.precoUnitario = 20000,
      this.value = 20000,
      this.parcels = 1,
      this.percentageTest,
      this.caixas = 20});

  @override
  Widget build(BuildContext context) {
    return precoUnitario != null
        ? Stack(
            fit: StackFit.loose,
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: 180,
                height: 170,
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
                          text: "${this.caixas}",
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 40),
                          children: [
                            TextSpan(
                              text: ' Caixas',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black45, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "R\$ ${Helper.intToMoney(this.precoUnitario)} por Cx.",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "${this.percentageTest}% de teste",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    Spacer(),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "Por ${Helper.intToMoney(this.value)}",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                right: 5,
                child: Icon(
                  MaterialCommunityIcons.plus_circle,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              )
            ],
          )
        : Container();
  }
}
