import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditoFinanceiroScreen extends StatefulWidget {
  @override
  _CreditoFinanceiroState createState() => _CreditoFinanceiroState();
}

class _CreditoFinanceiroState extends State<CreditoFinanceiroScreen> {
  MoneyMaskedTextController _creditValueController;

  CreditoFinanceiroBloc _creditoFinanceiroBloc =
      Modular.get<CreditoFinanceiroBloc>();

  @override
  void initState() {
    super.initState();
    _creditValueController = MoneyMaskedTextController(
      decimalSeparator: ',',
      leftSymbol: 'R\$ ',
      thousandSeparator: '.',
    );
  }

  void _addCreditoFinanceiro() {
    int value = (_creditValueController.numberValue * 100).toInt();
    _creditoFinanceiroBloc.creditoFinaceiroSink.add(CreditoFinanceiro(valor: value, installmentCount: 1, desconto: 0));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  @override
  void dispose() {
    _creditValueController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Credito Financeiro',
              style: Theme.of(context).textTheme.headline4),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFieldWidget(
                  labelText: 'Digite o valor',
                  controller: _creditValueController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: Color(0xffa1a1a1),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: (){
                      _addCreditoFinanceiro();
                    },
                    child: Text(
                      'Adicionar Crédito',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ))
            ]));
  }
}
