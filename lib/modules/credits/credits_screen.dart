import 'package:central_oftalmica_app_cliente/blocs/home_bloc.dart';
import 'package:central_oftalmica_app_cliente/widgets/card_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CreditsScreen extends StatefulWidget {
  @override
  _CreditsScreenState createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  HomeBloc _homeBloc = Modular.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            left: 20,
            right: 20,
            child: StreamBuilder<String>(
              stream: _homeBloc.currentCreditTypeOut,
              builder: (context, snapshot) {
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text(
                    snapshot.data == 'Financeiro' ? 'R\$' : 'Cx',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                  ),
                  title: Text(
                    snapshot.data == 'Financeiro' ? '567,00' : '2',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: 48,
                        ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: snapshot.data == 'Financeiro'
                            ? Icon(
                                Icons.attach_money,
                                color: Theme.of(context).primaryColor,
                                size: 30,
                              )
                            : Image.asset(
                                'assets/icons/open_box.png',
                                width: 25,
                                height: 25,
                              ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        snapshot.data == 'Financeiro'
                            ? 'Saldo atual'
                            : 'Total de Produtos',
                        style: Theme.of(context).textTheme.subtitle2,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<String>(
                stream: _homeBloc.currentCreditTypeOut,
                builder: (context, snapshot) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data == 'Financeiro' ? 5 : 3,
                    separatorBuilder: (context, index) => SizedBox(
                      width: 20,
                    ),
                    itemBuilder: (context, index) {
                      return snapshot.data == 'Financeiro'
                          ? CardWidget()
                          : ProductWidget(
                              credits: 1,
                              tests: 1,
                            );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: StreamBuilder<String>(
                stream: _homeBloc.currentCreditTypeOut,
                builder: (context, snapshot) {
                  return RaisedButton(
                    onPressed: () {},
                    child: Text(
                      snapshot.data == 'Financeiro'
                          ? 'Valor Personalizado'
                          : 'Comprar Crédito de Produto',
                      style: Theme.of(context).textTheme.button,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
