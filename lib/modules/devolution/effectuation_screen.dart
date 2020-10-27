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

  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();

  _onSubmit() {
    _devolutionWidgetBloc.sendEmail(_emailController.text);
    Modular.to.pushNamedAndRemoveUntil(
      '/home/0',
      (route) => route.isFirst,
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Devolução'),
        centerTitle: false,
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
            'Olá Marcos,\n\nVocê receberá uma cópia desta solicitação de devolução no e-mail cadastrado em nossa central.\n\nCaso deseje, adicione abaixo outro  e-mail para receber além do seu.',
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
          RaisedButton(
            onPressed: _onSubmit,
            child: Text(
              'Concluir Solicitação',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
