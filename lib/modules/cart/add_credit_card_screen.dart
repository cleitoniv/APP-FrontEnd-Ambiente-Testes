import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddCreditCardScreen extends StatefulWidget {
  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  TextEditingController _nameController;
  MaskedTextController _creditCardNumberController;
  MaskedTextController _validityController;
  MaskedTextController _cvvController;
  List<Map> _data;

  _onSubmit() {
    Modular.to.pop();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _creditCardNumberController = MaskedTextController(
      mask: '0000 0000 0000 0000',
    );
    _validityController = MaskedTextController(
      mask: '00/00',
    );
    _cvvController = MaskedTextController(
      mask: '000',
    );
    _data = [
      {
        'labelText': 'Nome impresso no cartão',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Número do cartãoo',
        'icon': MaterialCommunityIcons.credit_card,
        'controller': _creditCardNumberController,
      },
      {
        'labelText': 'Validade do cartão',
        'icon': MaterialCommunityIcons.calendar_month,
        'controller': _validityController,
      },
      {
        'labelText': 'CVV',
        'icon': MaterialCommunityIcons.card_bulleted,
        'controller': _cvvController,
      }
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditCardNumberController.dispose();
    _validityController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Cartão de Crédito'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Informações do Cartão',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _data.take(2).length,
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
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _data.skip(2).map(
              (e) {
                return TextFieldWidget(
                  width: e['labelText'] == 'Validade do cartão'
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 3.2,
                  labelText: e['labelText'],
                  prefixIcon: Icon(
                    e['icon'],
                    color: Color(0xffA1A1A1),
                  ),
                  controller: e['controller'],
                );
              },
            ).toList(),
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _onSubmit,
            child: Text(
              'Adicionar cartão',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
