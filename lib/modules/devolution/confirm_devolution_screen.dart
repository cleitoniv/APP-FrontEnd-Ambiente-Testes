import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ConfirmDevolutionScreen extends StatefulWidget {
  @override
  _ConfirmDevolutionScreenState createState() =>
      _ConfirmDevolutionScreenState();
}

class _ConfirmDevolutionScreenState extends State<ConfirmDevolutionScreen> {
  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();
  List<Map> _pacientInfo;
  List<Map> _productParams;
  TextEditingController _nameController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;

  _onChangeParams(Map<String, dynamic> data) async {
    Map<String, dynamic> _first =
        await _devolutionWidgetBloc.productParamsOut.first;

    if (_first == null) {
      _devolutionWidgetBloc.productParamsIn.add(data);
    } else {
      _devolutionWidgetBloc.productParamsIn.add({
        ..._first,
        ...data,
      });
    }

    Map<String, dynamic> _updatedFirst =
        await _devolutionWidgetBloc.productParamsOut.first;

    if (_updatedFirst['degree'] != null &&
        _updatedFirst['cylinder'] != null &&
        _updatedFirst['axis'] != null &&
        _updatedFirst['color'] != null &&
        _updatedFirst['addition'] != null) {
      _devolutionWidgetBloc.buttonCartStatusIn.add(true);
    }
  }

  _onSubmit() {}

  @override
  void initState() {
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );

    super.initState();
    _pacientInfo = [
      {
        'labelText': 'Nome do paciente',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Número do Cliente',
        'icon': MaterialCommunityIcons.format_list_numbered,
        'controller': _numberController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'controller': _birthdayController,
      },
    ];
    _productParams = [
      {
        'labelText': 'Escolha o Grau',
        'items': [0.5, 1.0, 1.5],
        'key': 'degree',
      },
      {
        'labelText': 'Escolha o Cilíndro',
        'items': ['Normal', 'Maior'],
        'key': 'cylinder',
      },
      {
        'labelText': 'Escolha o Eixo',
        'items': [0.9, 0.7],
        'key': 'axis',
      },
      {
        'labelText': 'Escolha a Cor',
        'items': ['Preto', 'Vermelho'],
        'key': 'color',
      },
      {
        'labelText': 'Escolha a Adição',
        'items': [1, 2, 3],
        'key': 'addition',
      }
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _birthdayController.dispose();
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
          ListTileMoreCustomizable(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 20,
            leading: CachedNetworkImage(
              imageUrl:
                  'https://onelens.fbitsstatic.net/img/p/lentes-de-contato-bioview-asferica-80342/353788.jpg?w=530&h=530&v=202004021417',
              width: 90,
              height: 90,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            title: Text(
              'Produto',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.black38,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            subtitle: Text(
              'Bioview Asferica Cx 6',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Divider(
            height: 50,
            thickness: 1,
          ),
          Text(
            'Informações do Paciente',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text(
            'Separe o pedido por paciente, assim você terá mais controle de reposição e acumulará Pontos que se tornam Crédito Financeiro!',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _pacientInfo.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return TextFieldWidget(
                labelText: _pacientInfo[index]['labelText'],
                prefixIcon: Icon(
                  _pacientInfo[index]['icon'],
                  color: Color(0xffA1A1A1),
                ),
                controller: _pacientInfo[index]['controller'],
              );
            },
          ),
          Text(
            'Parâmetros',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text(
            'Defina os parâmetros do produto',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: _productParams.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              return StreamBuilder<Map<String, dynamic>>(
                stream: _devolutionWidgetBloc.productParamsOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return DropdownWidget(
                    items: _productParams[index]['items'],
                    labelText: _productParams[index]['labelText'],
                    prefixIcon: SizedBox(),
                    currentValue: snapshot.data[_productParams[index]['key']],
                    onChanged: (value) => _onChangeParams({
                      _productParams[index]['key']: value,
                    }),
                  );
                },
              );
            },
          ),
          SizedBox(height: 30),
          StreamBuilder<bool>(
            stream: _devolutionWidgetBloc.buttonCartStatusOut,
            builder: (context, snapshot) {
              return Opacity(
                opacity: snapshot.data ? 1 : 0.5,
                child: RaisedButton.icon(
                  onPressed: snapshot.data ? _onSubmit : null,
                  elevation: 0,
                  disabledColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColor,
                  icon: Image.asset(
                    'assets/icons/cart.png',
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Confirmar Solicitação',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
