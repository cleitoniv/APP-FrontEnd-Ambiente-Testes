import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ActivityPerformedScreen extends StatefulWidget {
  @override
  _ActivityPerformedScreenState createState() =>
      _ActivityPerformedScreenState();
}

class _ActivityPerformedScreenState extends State<ActivityPerformedScreen> {
  List<Map> _activities = [
    {'id': 1, 'name': 'Oftalmologista'},
    {'id': 2, 'name': 'Ótica'},
    {'id': 3, 'name': 'Clínica, Hospital de Olhos ou Afins'},
    {'id': 4, 'name': 'Usuário de Lente Contato'},
  ];

  Map _currentActivity = {'id': null, 'name': ''};

  _handleActivity(value) {
    setState(() {
      _currentActivity = value;
    });
  }

  _handleSubmit() {
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
                  return RadioListTile(
                    value: _currentActivity['id'],
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
              ),
              Spacer(),
              Opacity(
                opacity: _currentActivity['id'] != null ? 1 : 0.5,
                child: RaisedButton(
                  onPressed:
                      _currentActivity['id'] != null ? _handleSubmit : null,
                  disabledColor: Theme.of(context).accentColor,
                  child: Text(
                    'Confirmar Atividade',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
