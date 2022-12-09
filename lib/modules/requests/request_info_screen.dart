import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/item_model.dart';
import 'package:central_oftalmica_app_cliente/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RequestInfoScreen extends StatelessWidget {
  final int id;
  final PedidoModel pedidoData;
  final bool reposicao;
  final RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();

  RequestInfoScreen({this.id, this.pedidoData, this.reposicao}) {
    _requestsBloc.getPedido(this.id, this.pedidoData, this.reposicao);
  }

  Map<String, String> parseOlho(Map<String, dynamic> item, String olho) {
    if (item['olho'] == olho) {
      return {
        "esferico": item['esferico'],
        "cilindro": item['cilindrico'],
        "eixo": item['eixo']
      };
    }
    return {"esferico": "-", "cilindro": "-", "eixo": "-"};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do pedido'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: _requestsBloc.pedidoInfoStream,
          builder: (context, pedidoInfo) {
            if (!pedidoInfo.hasData || pedidoInfo.data.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: <Widget>[
                  Text(
                    'Informações do Pedido',
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'Pedido nº',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Data do Pedido',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          Text(
                            '${pedidoInfo.data.pedido.numeroPedido}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontSize: 14,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${Helper.sqlToDate(pedidoInfo.data.pedido.dataInclusao)}",
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontSize: 14,
                                    ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Previsão de Entrega',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        Text(
                          pedidoInfo.data.pedido.previsaoEntrega ??
                              "Não informado.",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Produtos Comprados',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 18,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: pedidoInfo.data.pedido.items.length,
                        itemBuilder: (context, index) {
                          List<ItemPedidoModel> items =
                              pedidoInfo.data.pedido.items;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            padding: const EdgeInsets.all(20),
                            color: Color(0xffF1F1F1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Table(
                                  children: [
                                    TableRow(
                                      children: [
                                        Text(
                                          'Paciente',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Nº de Ref.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Nascimento',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Text(
                                          "${items[index].paciente ?? "-"}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                fontSize: 14,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "${items[index].numPac ?? "-"}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                fontSize: 14,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "${Helper.sqlToDate(items[index].dataNascimento)}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                fontSize: 14,
                                              ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                ListView.builder(
                                  itemCount: items[index].items.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index2) {
                                    bool isTest = items[index].items[index2]
                                    [
                                    'produto_teste'] !=
                                        null &&
                                        items[index].items[
                                        index2]
                                        ['tests'] ==
                                            "S";
                                    return Column(
                                      children: [
                                        ListTileMoreCustomizable(
                                            dense: true,
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            horizontalTitleGap: 0,
                                            leading: Image.asset(
                                              'assets/icons/info.png',
                                              width: 25,
                                              height: 25,
                                            ),
                                            title: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Quantidade selecionada tem duração recomendada de ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                          fontSize: 14,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${items[index].items[index2]['duracao']}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        .copyWith(
                                                          fontSize: 14,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        SizedBox(height: 10),
                                        ListTileMoreCustomizable(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            horizontalTitleGap: 10,
                                            leading: CachedNetworkImage(
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      'assets/images/no_image_product.jpeg'),
                                              imageUrl: items[index]
                                                  .items[index2]['imageUrl'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                            title: Row(
                                              children: [
                                                items[index].items[index2]
                                                                ['operation'] !=
                                                            "07" &&
                                                        items[index].items[
                                                                    index2]
                                                                ['tests'] ==
                                                            "N"
                                                    ? FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                          "${items[index].items[index2]['produto']}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                        ),
                                                      )
                                                    : items[index].items[index2]
                                                                    [
                                                                    'produto_teste'] !=
                                                                null &&
                                                            items[index].items[
                                                                        index2]
                                                                    ['tests'] ==
                                                                "S"
                                                        ? FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              "${items[index].items[index2]['produto_teste']}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          )
                                                        : FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              "${items[index].items[index2]['produto']}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                SizedBox(width: 20),
                                              ],
                                            ),
                                            subtitle: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Qnt. ${items[index].items[index2]['quantidade']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                        fontSize: 14,
                                                        color: Colors.black38,
                                                      ),
                                                ),
                                                SizedBox(width: 20),
                                                CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Helper.buyTypeBuildRequestInfo(
                                                                context,
                                                                items[index]
                                                                        .items[index2]
                                                                    ['operation'],
                                                                items[index]
                                                                        .items[index2]
                                                                    ['tests'])[
                                                            'background'],
                                                    child: Helper.buyTypeBuildRequestInfo(
                                                        context,
                                                        items[index]
                                                                .items[index2]
                                                            ['operation'],
                                                        items[index]
                                                                .items[index2]
                                                            ['tests'])['icon']),
                                                SizedBox(width: 10),
                                                Text(
                                                  "${Helper.buyTypeBuildRequestInfo(context, items[index].items[index2]['operation'], items[index].items[index2]['tests'])['title']}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black54,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            trailing: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                'R\$ ${isTest ? '0,00' : Helper.intToMoney(items[index].items[index2]['valorTotal'])}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5
                                                    .copyWith(
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            )),
                                        SizedBox(height: 20),
                                        // ListTileMoreCustomizable(
                                        //     dense: true,
                                        //     contentPadding:
                                        //         const EdgeInsets.all(0),
                                        //     horizontalTitleGap: 0,
                                        //     leading: Image.asset(
                                        //       'assets/icons/info.png',
                                        //       width: 25,
                                        //       height: 25,
                                        //     ),
                                        //     title: Text.rich(
                                        //       TextSpan(
                                        //         children: [
                                        //           TextSpan(
                                        //             text:
                                        //                 'Quantidade selecionada tem duração recomendada de ',
                                        //             style: Theme.of(context)
                                        //                 .textTheme
                                        //                 .subtitle1
                                        //                 .copyWith(
                                        //                   fontSize: 14,
                                        //                 ),
                                        //           ),
                                        //           TextSpan(
                                        //             text:
                                        //                 '${items[index].items[index2]['duracao']}',
                                        //             style: Theme.of(context)
                                        //                 .textTheme
                                        //                 .headline5
                                        //                 .copyWith(
                                        //                   fontSize: 14,
                                        //                 ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     )),
                                        // SizedBox(height: 50),
                                        Text(
                                          'Parâmetros',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10),
                                        Table(
                                          children: [
                                            TableRow(
                                              children: [
                                                Text(
                                                  'Olho esquerdo',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                        fontSize: 14,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Olho direito',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(
                                                        fontSize: 14,
                                                      ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              'Grau esférico',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black38,
                                                                  ))),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '${items[index].items[index2]["esfericoE"]}',
                                                            textScaleFactor:
                                                                1.25,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'Cilíndro',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["cilindricoE"]}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Eixo',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["eixoE"]}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'Adicao',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["adicaoE"] ?? "-"}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Cor',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["corE"] ?? "-"}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Qtd.',
                                                                textScaleFactor:
                                                                1.25,
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                  fontSize:
                                                                  14,
                                                                  color: Colors
                                                                      .black38,
                                                                ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["qtdE"] ?? "-"}',
                                                              textScaleFactor:
                                                              1.25,
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                fontSize:
                                                                14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                              ),
                                                            ))
                                                      ])
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                              'Grau esférico',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black38,
                                                                  ))),
                                                      Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            '${items[index].items[index2]["esfericoD"]}',
                                                            textScaleFactor:
                                                                1.25,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline5
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ))
                                                    ],
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'Cilíndro',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["cilindricoD"]}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Eixo',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["eixoD"]}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                                'Adicao',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["adicaoD"] ?? "-"}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Cor',
                                                                textScaleFactor:
                                                                    1.25,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black38,
                                                                    ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["corD"] ?? "-"}',
                                                              textScaleFactor:
                                                                  1.25,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  ),
                                                            ))
                                                      ]),
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text('Qtd.',
                                                                textScaleFactor:
                                                                1.25,
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    .copyWith(
                                                                  fontSize:
                                                                  14,
                                                                  color: Colors
                                                                      .black38,
                                                                ))),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${items[index].items[index2]["qtdD"] ?? "-"}',
                                                              textScaleFactor:
                                                              1.25,
                                                              style: Theme.of(
                                                                  context)
                                                                  .textTheme
                                                                  .headline5
                                                                  .copyWith(
                                                                fontSize:
                                                                14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                              ),
                                                            ))
                                                      ])
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          height: 50,
                                          thickness: 0.3,
                                          color: Colors.black38,
                                        )
                                      ],
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      )),
                  Divider(
                    height: 2,
                    thickness: 0.2,
                    color: Colors.black38,
                  ),
                  !this.reposicao
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              children: [
                                // TableRow(
                                //   children: [
                                // Text(
                                //   'Previsão de Entrega',
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .headline5
                                //       .copyWith(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.normal,
                                //       ),
                                // ),
                                Text(
                                  'Total + Frete',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  //   )
                                  // ],
                                ),
                                // TableRow(
                                //   children: [
                                // Text(
                                //   pedidoInfo.data.pedido.previsaoEntrega ??
                                //       "Não informado.",
                                //   style: Theme.of(context)
                                //       .textTheme
                                //       .subtitle1
                                //       .copyWith(
                                //         fontSize: 14,
                                //       ),
                                // ),
                                Text(
                                  'R\$ ${Helper.intToMoney(pedidoInfo.data.pedido.valorTotal)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                )
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            }
          },
        ));
  }
}
