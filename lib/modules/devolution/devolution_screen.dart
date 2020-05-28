import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DevolutionScreen extends StatefulWidget {
  @override
  _DevolutionScreenState createState() => _DevolutionScreenState();
}

class _DevolutionScreenState extends State<DevolutionScreen> {
  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();
  TextEditingController _serialController;

  _onChangeDevolutionType(String value) {
    _devolutionWidgetBloc.devolutionTypeIn.add(value);
  }

  _onAddProduct() {}

  _onSubmit() {}

  @override
  void initState() {
    super.initState();
    _serialController = TextEditingController();
  }

  @override
  void dispose() {
    _serialController.dispose();
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
          Text(
            'Devolução para Crédito ou Troca',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Selecione o tipo de',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                TextSpan(
                  text: ' Devolução ',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
                TextSpan(
                  text: 'que deseja, informe o',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                TextSpan(
                  text: ' Número de Série ',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
                TextSpan(
                  text: 'dos Produtos e',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                TextSpan(
                  text: ' Adicione-os a Lista.',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          StreamBuilder<String>(
            stream: _devolutionWidgetBloc.devolutionTypeOut,
            builder: (context, snapshot) {
              return DropdownWidget(
                items: ['Crédito', 'Troca'],
                labelText: 'Selecione o tipo de Devolução',
                currentValue: snapshot.data,
                onChanged: _onChangeDevolutionType,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/icons/return.png',
                    width: 5,
                    height: 5,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          TextFieldWidget(
            controller: _serialController,
            labelText: 'Número de Série do Produto',
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'assets/icons/open_eye.png',
                width: 5,
                height: 5,
                fit: BoxFit.contain,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 30),
          RaisedButton.icon(
            onPressed: _onAddProduct,
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
            icon: Icon(
              MaterialCommunityIcons.plus,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Adicionar Produto a Lista',
              style: Theme.of(context).textTheme.button.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Produtos Adicionados',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _onSubmit,
            child: Text(
              'Continuar Solicitação',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
