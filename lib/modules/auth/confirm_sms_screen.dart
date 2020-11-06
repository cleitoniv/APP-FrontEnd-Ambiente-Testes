import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ConfirmSmsScreen extends StatefulWidget {
  Map<String, dynamic> phone;

  ConfirmSmsScreen({this.phone});
  @override
  _ConfirmSmsState createState() => _ConfirmSmsState();
}

class _ConfirmSmsState extends State<ConfirmSmsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  TextEditingController _confirmSms;
  MaskedTextController _phoneController;
  String _requestCodeController;
  bool _lock = false;

  _showDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text(content),
          actions: [
            RaisedButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Modular.to.pop();
                })
          ],
        );
      },
    );
  }

  _handleConfirmSms() async {
    if (_confirmSms.text.trim().length == 0) {
      _showDialog("Atenção", "Preencha o campo código!");
      return;
    }
    String phonex = widget.phone["phone"].replaceAll('-', '');
    String ddd = widget.phone["ddd"];
    phonex = phonex.replaceAll(' ', '');
    // phonex = "${ddd + phonex}";
    bool codeMatch = await _authWidgetBloc.confirmSms(
        int.parse(_confirmSms.text), int.parse(phonex));

    if (codeMatch) {
      Modular.to.pushNamed('/auth/activityPerformed');
    } else {
      _showDialog("Atenção", "Código Inválido ou expirado!");
    }
  }

  _requireCodeSms() async {
    String userPhone = widget.phone["phone"].replaceAll('-', '');
    String ddd = widget.phone["ddd"];

    userPhone = userPhone.replaceAll(' ', '');
    print(userPhone);
    bool codeGenerated =
        await _authWidgetBloc.requireCodeSms(int.parse(userPhone));
    if (!codeGenerated) {
      _showDialog("Atenção",
          "Não foi possível enviar o código! Por favor, tente novamente");
    } else {
      setState(() {
        _lock = true;
        _requestCodeController = "60 seg...";
      });
      Timer(Duration(seconds: 10), () {
        setState(() {
          _lock = false;
          _requestCodeController = "Receber";
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _requireCodeSms();
    _confirmSms = TextEditingController();
    _phoneController = MaskedTextController(
      mask: '00 00000-0000',
    );
    _phoneController.text = widget.phone["phone"];
    _requestCodeController = "Receber";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Confirme o Código Recebido"),
        centerTitle: false,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Digite o telefone utilizado no seu cadastro",
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            TextFieldWidget(
              keyboardType: TextInputType.number,
              controller: _phoneController,
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xffa1a1a1),
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(left: 270),
              child: RaisedButton(
                onPressed: _lock ? null : _requireCodeSms,
                child: Text(
                  _requestCodeController,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ),
            Text(
              "Digite o Código SMS Recebido",
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            TextFieldWidget(
              hint: '* * * * * * * * *',
              keyboardType: TextInputType.number,
              controller: _confirmSms,
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xffa1a1a1),
              ),
            ),
            SizedBox(height: 30),
            RaisedButton(
              onPressed: _handleConfirmSms,
              child: Text(
                'Confirmar',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
