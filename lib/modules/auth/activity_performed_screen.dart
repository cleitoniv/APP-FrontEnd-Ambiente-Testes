import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ActivityPerformedScreen extends StatefulWidget {
  @override
  _ActivityPerformedScreenState createState() =>
      _ActivityPerformedScreenState();
}

class _ActivityPerformedScreenState extends State<ActivityPerformedScreen> {
  AuthWidgetBloc _authWidgetBloc = Modular.get<AuthWidgetBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();

  List<Map<String, dynamic>> _activities = [
    {'id': "1", 'name': 'Oftalmologista', 'fisica_jurid': 'F'},
    {'id': "2", 'name': 'Ótica', 'fisica_jurid': 'J'},
    {'id': "3", 'name': 'Clínica, Hospital de Olhos ou Afins', 'fisica_jurid': 'J'},
    {'id': "4", 'name': 'Usuário de Lente Contato', 'fisica_jurid': 'F'},
  ];

  _handleActivity(Map<String, dynamic> value) {
    _authWidgetBloc.currentActivityIn.add(
      value,
    );
  }

  _handleSubmit() async {
    Map<String, dynamic> _first =
        await _authWidgetBloc.currentActivityOut.first;

    _authWidgetBloc.addUserInfo({
      'activity': _first['name'],
      'ramo': _first['id'],
      'fisica_jurid': _first['fisica_jurid']
    });

    Modular.to.pushNamed(
      '/auth/completeCreateAccount',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atividade exercida',
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                'O que descreve melhor a sua atividade?',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ListView.separated(
                shrinkWrap: true,
                itemCount: _activities.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  return StreamBuilder<Map<String, dynamic>>(
                    stream: _authWidgetBloc.currentActivityOut,
                    builder: (context, snapshot) {
                      return RadioListTile(
                        value: snapshot.hasData ? snapshot.data['id'] : null,
                        groupValue: _activities[index]['id'],
                        onChanged: (value) => _handleActivity(
                          _activities[index],
                        ),
                        title: Text(
                          _activities[index]['name'],
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      );
                    },
                  );
                },
              ),
              Spacer(),
              StreamBuilder<Map<String, dynamic>>(
                stream: _authWidgetBloc.currentActivityOut,
                builder: (context, snapshot) {
                  return Opacity(
                    opacity: snapshot.hasData ? 1 : 0.5,
                    child: RaisedButton(
                      onPressed: snapshot.hasData ? _handleSubmit : null,
                      disabledColor: Theme.of(context).accentColor,
                      child: Text(
                        'Confirmar Atividade',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
