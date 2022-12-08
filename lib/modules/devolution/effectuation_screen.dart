import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EffectuationScreen extends StatefulWidget {
  @override
  _EffectuationScreenState createState() => _EffectuationScreenState();
}

class _EffectuationScreenState extends State<EffectuationScreen> {
  TextEditingController _emailController;
  bool _isLoadingButton;
  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();
// S01147461
  _onSubmit() async {
    setState(() {
      _isLoadingButton = true;
    });
    await _devolutionWidgetBloc.sendEmail(_emailController.text);
    setState(() {
      _isLoadingButton = false;
    });
    Modular.to.pushNamedAndRemoveUntil(
      '/home/0',
      (route) => route.isFirst,
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _isLoadingButton = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Devolução'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Efetivação de Devolução',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Você receberá uma cópia desta solicitação de Devolução no e-mail cadastrado em nossa central.\n\nCaso deseje, adicione abaixo outro e-mail para receber além do seu.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 20),
            TextFieldWidget(
              labelText: 'Email alternativo',
              controller: _emailController,
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xffa1a1a1),
              ),
            ),
            SizedBox(height: 30),
            !_isLoadingButton
                ? ElevatedButton(
                    onPressed: _onSubmit,
                    child: Text(
                      'Concluir Solicitação',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                : Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
