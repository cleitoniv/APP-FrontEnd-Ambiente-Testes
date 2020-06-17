import 'package:central_oftalmica_app_cliente/blocs/cart_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  CartWidgetBloc _cartWidgetBloc = Modular.get<CartWidgetBloc>();

  _onAddCreditCard() {
    Modular.to.pushNamed('/cart/addCreditCard');
  }

  _onChangePaymentForm(int index) {
    _cartWidgetBloc.currentPaymentFormIn.add(index);
  }

  _onSubmitDialog() {
    Modular.to.pushNamedAndRemoveUntil(
      '/home/3',
      (route) => route.isFirst,
    );
  }

  _onSubmit() {
    Dialogs.success(context,
        subtitle: 'Compra efetuada com sucesso!',
        buttonText: 'Ir para Meus Pedidos',
        onTap: _onSubmitDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppBar(
                title: Text('Pagamento'),
                centerTitle: false,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 18,
                          ),
                    ),
                    Text(
                      'R\$ ${Helper.intToMoney(20000)}',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 18,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        children: <Widget>[
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemCount: 4,
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            itemBuilder: (context, index) {
              return StreamBuilder<int>(
                stream: _cartWidgetBloc.currentPaymentFormOut,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    duration: Duration(
                      milliseconds: 100,
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: snapshot.data == index
                          ? Theme.of(context).accentColor
                          : Color(0xffF1F1F1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTileMoreCustomizable(
                      onTap: (value) => _onChangePaymentForm(
                        index,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 10,
                      leading: Image.asset(
                        'assets/icons/barcode.png',
                        width: 30,
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                      title: Text(
                        'À vista (5% de desconto)',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  snapshot.data == index ? Colors.white : null,
                            ),
                      ),
                      trailing: snapshot.data == index
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                },
              );
            },
          ),
          RaisedButton.icon(
            onPressed: _onAddCreditCard,
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
              'Adicionar Outro Cartão',
              style: Theme.of(context).textTheme.button.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: _onSubmit,
            child: Text(
              'Finalizar Pedido',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
