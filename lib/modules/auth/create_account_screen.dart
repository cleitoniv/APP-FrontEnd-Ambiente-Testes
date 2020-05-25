import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastre-se',
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Seja bem-vindo!',
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }
}
