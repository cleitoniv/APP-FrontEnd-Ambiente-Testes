import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CardWidget extends StatelessWidget {
  int value;
  int parcels;

  CardWidget({
    this.value = 20000,
    this.parcels = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          width: 170,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xffF1F1F1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text.rich(
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
              Text(
                'De créditos',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.black45,
                      fontSize: 14,
                    ),
              ),
              Spacer(),
              Text(
                parcels == 1 ? 'À vista' : 'Até ${parcels}x',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Theme.of(context).accentColor,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 100,
          right: -10,
          child: Icon(
            MaterialCommunityIcons.plus_circle,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
        )
      ],
    );
  }
}
