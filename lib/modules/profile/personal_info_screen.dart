import 'package:central_oftalmica_app_cliente/blocs/profile_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  ProfileBloc _profileBloc = Modular.get<ProfileBloc>();
  TextEditingController _nameController;
  MaskedTextController _cpfController;
  MaskedTextController _birthdayController;
  TextEditingController _emailController;
  MaskedTextController _phoneController;

  List<Map> _personalInfo;

  _onChangeVisitHour(String value) {
    _profileBloc.visitHourIn.add(value);
  }

  _onSaveNewSchedule() {}

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _cpfController = MaskedTextController(
      mask: '000.000.000-00',
    );
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );
    _emailController = TextEditingController();
    _phoneController = MaskedTextController(
      mask: '00 00000-0000',
    );

    _personalInfo = [
      {
        'labelText': 'Nome completo',
        'icon': Icons.person,
        'value': 'Marcos Barbosa Santos',
        'controller': _nameController,
      },
      {
        'labelText': 'CPF',
        'icon': Icons.person,
        'value': '12345678900',
        'controller': _cpfController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': Icons.cake,
        'value': '25091990',
        'controller': _birthdayController,
      },
      {
        'labelText': 'Email',
        'icon': Icons.email,
        'value': 'marcos@hotmail.com',
        'controller': _emailController,
      },
      {
        'labelText': 'Celular',
        'icon': Icons.phone_android,
        'value': '27999999999',
        'controller': _phoneController,
      },
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações Pessoais'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Informações do Sistema',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: [
                  Text(
                    'Cód. Cliente',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Dia da Remessa',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).accentColor,
                          fontSize: 14,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TableRow(
                children: [
                  Text(
                    '123456',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Quarta-Feira',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Selecione o melhor horário de visita',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text(
            'Caso tenha um representante Central Oftálmica informe abaixo o melhor horário para o mesmo visita-lo',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              labelText: 'Horário de Visita',
              labelStyle: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
              alignLabelWithHint: true,
              prefixIcon: Icon(
                Icons.remove_red_eye,
                color: Color(0xffA1A1A1),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: StreamBuilder<String>(
                stream: _profileBloc.visitHourOut,
                builder: (context, snapshot) {
                  return DropdownButton(
                    value: snapshot.data,
                    items: ['Manhã', 'Tarde', 'Noite'].map(
                      (e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      },
                    ).toList(),
                    onChanged: _onChangeVisitHour,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 30),
          RaisedButton(
            elevation: 0,
            onPressed: _onSaveNewSchedule,
            child: Text(
              'Salvar Novo Horário',
              style: Theme.of(context).textTheme.button,
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Informações Pessoais',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _personalInfo.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return TextFieldWidget(
                enabled: false,
                labelText: _personalInfo[index]['labelText'],
                prefixIcon: Icon(
                  _personalInfo[index]['icon'],
                  color: Color(0xffA1A1A1),
                ),
                controller: _personalInfo[index]['controller']
                  ..text = _personalInfo[index]['value'],
              );
            },
          )
        ],
      ),
    );
  }
}
