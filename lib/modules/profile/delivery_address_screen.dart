import 'package:central_oftalmica_app_cliente/modules/auth/login_screen.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  List<Map> _addressInfo;

  MaskedTextController _zipCodeController;
  TextEditingController _addressController;
  TextEditingController _houseNumberController;
  TextEditingController _adjunctController;
  TextEditingController _districtController;
  TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _zipCodeController = MaskedTextController(
      mask: '000000-00',
    );
    _addressController = TextEditingController();
    _houseNumberController = TextEditingController();
    _adjunctController = TextEditingController();
    _districtController = TextEditingController();
    _cityController = TextEditingController();

    _addressInfo = [
      {
        'labelText': 'CEP',
        'value': '290550445',
        'controller': _zipCodeController,
      },
      {
        'labelText': 'Endereço',
        'value': 'Rua Dr. Eurico de Aguiar',
        'controller': _addressController,
      },
      {
        'labelText': 'Número',
        'value': '130',
        'controller': _houseNumberController,
      },
      {
        'labelText': 'Complemento',
        'value': 'Sala 609',
        'controller': _adjunctController,
      },
      {
        'labelText': 'Bairro',
        'value': 'Santa Helena',
        'controller': _districtController,
      },
      {
        'labelText': 'Cidade',
        'value': 'Vitória',
        'controller': _cityController,
      },
    ];
  }

  @override
  void dispose() {
    _zipCodeController.dispose();
    _addressController.dispose();
    _houseNumberController.dispose();
    _adjunctController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endereço de Entrega'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Endereço Cadastrado',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Caso tenha um representante Central Oftálmica informe abaixo o melhor horário para o mesmo visita-lo ',
                  style: Theme.of(context).textTheme.subtitle1,
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(
                  text: 'deste link',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                        decoration: TextDecoration.underline,
                      ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _addressInfo.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return TextFieldWidget(
                enabled: false,
                labelText: _addressInfo[index]['labelText'],
                prefixIcon: Icon(
                  Icons.map,
                  color: Color(0xffA1A1A1),
                ),
                controller: _addressInfo[index]['controller']
                  ..text = _addressInfo[index]['value'],
              );
            },
          )
        ],
      ),
    );
  }
}
