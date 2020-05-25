import 'package:flutter/material.dart';

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

  _handleSubmit() {}

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'O que descreve melhor a sua atividade?',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
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
          Opacity(
            opacity: _currentActivity['id'] != null ? 1 : 0.5,
            child: RaisedButton(
              onPressed: _currentActivity['id'] != null ? _handleSubmit : null,
              disabledColor: Theme.of(context).accentColor,
              child: Text(
                'Cadastrar',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
