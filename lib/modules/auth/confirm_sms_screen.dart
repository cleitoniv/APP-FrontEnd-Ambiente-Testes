import 'package:flutter/material.dart';

class ConfirmSmsScreen extends StatefulWidget {
  @override
  _ConfirmSmsState createState() => _ConfirmSmsState();
}

class _ConfirmSmsState extends State<ConfirmSmsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirme o Código Recebido"),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [Text("Digite o Código SMS Recebido ")],
        ),
      )),
    );
  }
}
