import 'dart:developer';

import 'package:central_oftalmica_app_cliente/blocs/credito_financeiro.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/models/offer.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../blocs/product_bloc.dart';

class CreditoFinanceiroScreen extends StatefulWidget {
  @override
  _CreditoFinanceiroState createState() => _CreditoFinanceiroState();
}

class _CreditoFinanceiroState extends State<CreditoFinanceiroScreen> {
  MoneyMaskedTextController _creditValueController;

  ProductBloc _productsBloc = Modular.get<ProductBloc>();
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
    _creditValueController.addListener(() {
      setState(() {
        _creditValueController.numberValue;
      });
    });
  }

  void _addCreditoFinanceiro() {
    if (_creditValueController.value.text == "R\$ 0,00") {
      Dialogs.errorWithWillPopScope(context,
          title: "Valor incorreto",
          subtitle: "Digite um valor valido!", onTap: () {
        Modular.to.pop();
      }, buttonText: "OK");
      return;
    }
    int value = (_creditValueController.numberValue * 100).toInt();
    _creditoFinanceiroBloc.creditoFinaceiroSink
        .add(CreditoFinanceiro(valor: value, installmentCount: 1, desconto: 0));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  _verifyDiscount(valor, offers, hasdata) {
    print(hasdata);
    if (offers != null) {
      if (hasdata) {
        List<int> percentage = [];
        List<int> valueTotal = [];
        List<OfferModel> list = offers.offers;
        for (var i = 0; i < list.length; i++) {
          valueTotal.add(list[i].value);
        }
        for (var i = 0; i < list.length; i++) {
          percentage.add(list[i].discount);
        }

        if (valor.numberValue.truncate() * 100 > 0 &&
            valor.numberValue.truncate() * 100 < valueTotal[1]) {
          return percentage[0];
        } else if (valor.numberValue.truncate() * 100 >= valueTotal[1] &&
            valor.numberValue.truncate() * 100 < valueTotal[2]) {
          return percentage[1];
        } else if (valor.numberValue.truncate() * 100 >= valueTotal[2]) {
          return percentage[2];
        } else {
          return 0;
        }
      } else
        return 0;
    } else {
      return 0;
    }
  }

  @override
  void dispose() {
    // _creditValueController.clear();
    _creditValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _productsBloc.offersRedirectedStream,
        builder: (context, offerSnapshot) {
          var offers = offerSnapshot.data;
          print('linha 102');
          return Scaffold(
            appBar: AppBar(
              title: Text('Credito Financeiro',
                  style: Theme.of(context).textTheme.headline4),
            ),
            body: Column(children: [
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
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      18.0,
                    ),
                    child: Text(
                        'Desconto com o valor atual:  ${_verifyDiscount(_creditValueController, offers, offerSnapshot.hasData)}%',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontSize: 16)),
                  )
                ],
              )),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  onPressed: () {
                    _addCreditoFinanceiro();
                  },
                  child: Text(
                    'Adicionar Crédito',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ]),
          );
        });
  }
}
