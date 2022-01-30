import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProductWidget extends StatelessWidget {
  final int tests;
  final int credits;
  final String title;
  final int value;
  final String imageUrl;
  final double width;
  final Function onTap;
  final int boxes;

  ProductWidget({
    this.tests = 0,
    this.credits = 0,
    this.title = 'Produto',
    this.value = 0,
    this.imageUrl =
        'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
    this.width = 170,
    this.onTap,
    this.boxes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                credits != 0
                    ? Container(
                        width: 70,
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
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$credits',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        width: 70,
                        height: 36,
                      ),
                tests != 0
                    ? Container(
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
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$tests',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            )
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
            SizedBox(height: 7,),
            CachedNetworkImage(
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/no_image_product.jpeg'),
              imageUrl: imageUrl,
              width: 120,
              height: 100,
              fit: BoxFit.fill,
            ),
            Text(
              title,
              textScaleFactor: 1.08,
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
            ),
            value != 0
                ? FittedBox(
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class ProductProfileWidget extends StatelessWidget {
  final int tests;
  final int credits;
  final String title;
  final int value;
  final String imageUrl;
  final double width;
  final Function onTap;
  final int boxes;

  ProductProfileWidget({
    this.tests = 0,
    this.credits = 0,
    this.title = 'Produto',
    this.value = 0,
    this.imageUrl =
    'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
    this.width = 170,
    this.onTap,
    this.boxes,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                credits != 0
                    ? Container(
                  width: 70,
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
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '$credits',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      )
                    ],
                  ),
                )
                    : SizedBox(
                  width: 70,
                  height: 36,
                ),
                tests != 0
                    ? Container(
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
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '$tests',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      )
                    ],
                  ),
                )
                    : Container()
              ],
            ),
            SizedBox(height: 7,),
            CachedNetworkImage(
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/no_image_product.jpeg'),
              imageUrl: imageUrl,
              width: 120,
              height: 100,
              fit: BoxFit.fill,
            ),
            value != 0
                ? FittedBox(
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
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
