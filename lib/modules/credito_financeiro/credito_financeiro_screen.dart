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

  _parcels(valor, offers) {
    var installment = 1;
    List<OfferModel> list = offers.offers ?? [];
    for (var i = 0; i < list.length; i++) {
      if (valor >= list[i].value) {
        installment = list[i].installmentCount;
      }
    } 
    return installment;
  }

  void _addCreditoFinanceiro(offers) {
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
        .add(CreditoFinanceiro(valor: value, installmentCount: _parcels(value, offers), desconto: 0));
    Modular.to.pushNamed('/credito_financeiro/pagamento');
  }

  _verifyDiscount(valor, offers, hasdata) {
    if (offers != null && offers.offers.length > 0) {
      if (hasdata) {
        double percentage = 0;
        List<OfferModel> list = offers.offers ?? [];
        for (var i = 0; i < list.length; i++) {
          if (valor.numberValue.truncate() * 100 >= list[i].value) {
           percentage = list[i].discount;
          }
        } 
        return percentage ?? 0;
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
                        offers == null
                            ? 'Sem desconto no momento.'
                            : 'Desconto com o valor atual:  ${_verifyDiscount(_creditValueController, offers, offerSnapshot.hasData)}%',
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
                  onPressed: offers == null
                      ? () {}
                      : () {
                          _addCreditoFinanceiro(offers);
                        },
                  child: offers == null
                      ? Text(
                          'Indisponível no momento',
                          style: TextStyle(color: Colors.grey),
                        )
                      : Text(
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
