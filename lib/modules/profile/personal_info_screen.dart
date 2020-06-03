import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  UserBloc _userBloc = Modular.get<UserBloc>();
  ProfileWidgetBloc _profileWidgetBloc = Modular.get<ProfileWidgetBloc>();
  TextEditingController _nameController;
  MaskedTextController _cpfController;
  MaskedTextController _birthdayController;
  TextEditingController _emailController;
  MaskedTextController _phoneController;

  List<Map> _personalInfo = [];

  _onChangeVisitHour(value) {
    _profileWidgetBloc.visitHourIn.add(value);
  }

  _onSaveNewSchedule() {}

  _initData() async {
    UserModel _user = await _userBloc.currentUserOut.first;

    _personalInfo = [
      {
        'labelText': 'Nome completo',
        'icon': Icons.person,
        'value': _user.name,
        'controller': _nameController,
      },
      {
        'labelText': 'CPF',
        'icon': Icons.person,
        'value': _user.cpf,
        'controller': _cpfController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'value': _user.birthday,
        'controller': _birthdayController,
      },
      {
        'labelText': 'Email',
        'icon': Icons.email,
        'value': _user.email,
        'controller': _emailController,
      },
      {
        'labelText': 'Celular',
        'icon': MaterialCommunityIcons.cellphone,
        'value': _user.cellphone,
        'controller': _phoneController,
      },
    ];
  }

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
    _initData();
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
                  StreamBuilder<UserModel>(
                    stream: _userBloc.currentUserOut,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data.code : '',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  StreamBuilder<UserModel>(
                    stream: _userBloc.currentUserOut,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData
                            ? Helper.dateToWeek(
                                snapshot.data.dayOfSend,
                              )
                            : '',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      );
                    },
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
          SizedBox(height: 10),
          Text(
            'Caso tenha um representante Central Oftálmica informe abaixo o melhor horário para o mesmo visita-lo',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          StreamBuilder<UserModel>(
            stream: _userBloc.currentUserOut,
            builder: (context, snapshot) {
              return DropdownWidget(
                items: ['Manhã', 'Tarde', 'Noite'],
                currentValue: snapshot.hasData ? snapshot.data.visitHour : null,
                onChanged: _onChangeVisitHour,
              );
            },
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
          StreamBuilder<UserModel>(
            stream: _userBloc.currentUserOut,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  heightFactor: 3,
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
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
              );
            },
          )
        ],
      ),
    );
  }
}
