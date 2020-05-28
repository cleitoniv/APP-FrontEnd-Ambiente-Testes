import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddPointsScreen extends StatefulWidget {
  @override
  _AddPointsScreenState createState() => _AddPointsScreenState();
}

class _AddPointsScreenState extends State<AddPointsScreen> {
  List<Map> _data;

  TextEditingController _nameController;
  TextEditingController _serialController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;

  _onSubmitDialog() {
    Modular.to.pop();
    Modular.to.pop();
  }

  _onSubmit() {
    Dialogs.success(
      context,
      subtitle: 'Pontos adicionados com sucesso!',
      buttonText: 'Ir para os Meus Pontos',
      onTap: _onSubmitDialog,
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _serialController = TextEditingController();
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );
    _data = [
      {
        'labelText': 'Nome do paciente',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Número de Referência do Paciente',
        'icon': MaterialCommunityIcons.numeric,
        'controller': _numberController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'controller': _birthdayController,
      },
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _birthdayController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Pontos'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Como adicionar Pontos',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Digite o número de série do produto, nome, número de referência (opcional) e data de nascimento do paciente que receberá e acumule pontos!',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          TextFieldWidget(
            controller: _serialController,
            labelText: 'Número de série',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(13),
              child: Image.asset(
                'assets/icons/open_eye.png',
                width: 5,
                height: 0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _data.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return TextFieldWidget(
                labelText: _data[index]['labelText'],
                prefixIcon: Icon(
                  _data[index]['icon'],
                  color: Color(0xffA1A1A1),
                ),
                controller: _data[index]['controller'],
              );
            },
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _onSubmit,
            child: Text(
              'Solicitar Pontos',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
