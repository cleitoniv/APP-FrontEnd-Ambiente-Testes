import 'package:flutter/material.dart';

class TabsScreen extends StatelessWidget {
  int currentIndex;

  TabsScreen({
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    print(currentIndex);
    return Scaffold();
  }
}
