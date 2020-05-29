import 'package:flutter/material.dart';

class Modals {
  static params(
    BuildContext context, {
    Map<dynamic, dynamic> items,
    Function(Map<dynamic, dynamic>, double) onTap,
    String title = 'Selecione os graus',
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 18,
                    ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: items['items'].length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 5,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onTap(items, items['items'][index]),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black26,
                      ),
                    ),
                    child: Text(
                      '${items['items'][index]}',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
