import 'package:flutter/material.dart';

class ErrorSnackBar {
  static SnackBar snackBar(
      BuildContext context, Map<String, dynamic> errorData) {
    return SnackBar(
      backgroundColor: Colors.white,
      content: Container(
        constraints: BoxConstraints(
            maxHeight: (errorData.keys.length * 90).toDouble(), maxWidth: 300),
        child: ListView(
          children: [
            Column(
              children: errorData.keys.map((e) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 3,
                            blurRadius: 3,
                            color: Colors.grey.withOpacity(0.1),
                            offset: Offset(0, 2))
                      ],
                      border: Border.all(color: Colors.grey.withOpacity(0.2))),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 1,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red.withOpacity(0.2),
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              )),
                          Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$e",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ...errorData[e].map((p) {
                                    return Text(
                                      "$p",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 15),
                                    );
                                  })
                                ],
                              ))
                        ],
                      )),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
