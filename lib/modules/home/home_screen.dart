import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xffFAF4E4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/icons/open_box.png',
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '2',
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xffE6E6E6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MaterialCommunityIcons.eye,
                          color: Colors.black45,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '2',
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/product.png',
                width: 150,
                height: 120,
              ),
              Text(
                'Biosoft Asférica Mensal',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 14,
                    ),
              ),
              Text.rich(
                TextSpan(
                  text: 'R\$ ',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontSize: 14,
                      ),
                  children: [
                    TextSpan(
                      text: '567,00',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
