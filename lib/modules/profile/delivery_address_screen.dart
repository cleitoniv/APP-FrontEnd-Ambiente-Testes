import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/endereco_entrega.dart';
import 'package:central_oftalmica_app_cliente/models/user_model.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/login_screen.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  UserBloc _userBloc = Modular.get<UserBloc>();
  List<Map> _addressInfo = [];
  MaskedTextController _zipCodeController;
  TextEditingController _addressController;
  TextEditingController _houseNumberController;
  TextEditingController _adjunctController;
  TextEditingController _districtController;
  TextEditingController _cityController;

  String getField(EnderecoEntregaModel endereco, String label) {
    if (label == "CEP") {
      return endereco.cep;
    } else if (label == "Endereço") {
      return endereco.endereco;
    } else if (label == "Número") {
      return endereco.numero;
    } else if (label == "Complemento") {
      return endereco.complemento;
    } else if (label == "Bairro") {
      return endereco.bairro;
    } else if (label == "Cidade") {
      return endereco.municipio;
    }
  }

  _initData() async {
    UserModel _user = await _userBloc.currentUserOut.first;

    _addressInfo = [
      {
        'labelText': 'CEP',
        'controller': _zipCodeController,
      },
      {
        'labelText': 'Endereço',
        'controller': _addressController,
      },
      {
        'labelText': 'Número',
        'controller': _houseNumberController,
      },
      {
        'labelText': 'Complemento',
        'controller': _adjunctController,
      },
      {
        'labelText': 'Bairro',
        'controller': _districtController,
      },
      {
        'labelText': 'Cidade',
        'controller': _cityController,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _zipCodeController = MaskedTextController(
      mask: '00000-000',
    );
    _addressController = TextEditingController();
    _houseNumberController = TextEditingController();
    _adjunctController = TextEditingController();
    _districtController = TextEditingController();
    _cityController = TextEditingController();

    _userBloc.getEnderecoEntrega();

    _initData();
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
          SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                // TextSpan(
                //   text:
                //       'Caso tenha um representante Central Oftálmica informe abaixo o melhor horário para o mesmo visita-lo ',
                //   style: Theme.of(context).textTheme.subtitle1,
                // ),
                // TextSpan(
                //   text: 'deste link',
                //   style: Theme.of(context).textTheme.subtitle1.copyWith(
                //         color: Theme.of(context).accentColor,
                //         decoration: TextDecoration.underline,
                //       ),
                //   recognizer: TapGestureRecognizer()..onTap = () {},
                // ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          StreamBuilder(
              stream: _userBloc.enderecoEntregaStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isLoading) {
                  return Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data.isEmpty) {
                  return Center(
                      child: Text(
                          "Erro ao carregar endereço, tente novamente mais tarde"));
                }
                return ListView.separated(
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
                        MaterialCommunityIcons.map_marker,
                        color: Color(0xffA1A1A1),
                      ),
                      controller: _addressInfo[index]['controller']
                        ..text =
                            "${getField(snapshot.data.endereco, _addressInfo[index]['labelText'])}",
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
