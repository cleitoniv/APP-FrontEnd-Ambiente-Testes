import 'package:central_oftalmica_app_cliente/blocs/extract_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class ProductExtractScreen extends StatelessWidget {
  ExtractWidgetBloc _extractWidgetBloc = Modular.get<ExtractWidgetBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _extractWidgetBloc.extratoProdutoStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(
              child: Text("Não foi possivel carregar seu extrato no momento."),
            );
          }

          return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "${snapshot.data.date}",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: snapshot.data.data.map<Widget>((e) {
                          if (e.saldo != 0) {
                            return Column(
                              children: [
                                ListTileMoreCustomizable(
                                  contentPadding: const EdgeInsets.all(0),
                                  horizontalTitleGap: 0,
                                  leading: CircleAvatar(
                                    backgroundColor: Color(0xffF1F1F1),
                                    radius: 15,
                                    child: Image.asset(
                                      'assets/icons/open_box.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                  title: Text(
                                    "${e.produto}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                  trailing: Text(
                                    'Saldo: ${e.saldo}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                ),
                                Table(
                                  border: TableBorder.symmetric(
                                    outside: BorderSide(
                                      width: 0.2,
                                    ),
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                          'Data',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Pedido',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Quantidade',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Table(
                                  border: TableBorder.all(
                                    width: 0.2,
                                  ),
                                  children: e.items.map<TableRow>((p) {
                                    print(p['quantidade']);
                                    return TableRow(
                                      children: [
                                        Text(
                                          "${p['date']}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black26,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "${p['pedido']}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                color: Colors.black26,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          (p['quantidade'] as int) <= 0
                                              ? '${p['quantidade']}'
                                              : '+ ${p['quantidade']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                fontSize: 14,
                                                color:
                                                    (p['quantidade'] as int) <=
                                                            0
                                                        ? Colors.black26
                                                        : Theme.of(context)
                                                            .primaryColor,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }).toList()),
                  )
                ],
              ));
        });
  }
}
