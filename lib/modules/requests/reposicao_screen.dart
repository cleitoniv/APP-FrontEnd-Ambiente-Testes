import 'dart:async';

import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/pedido_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RepositionScreen extends StatefulWidget {
  @override
  _RepositionScreenState createState() => _RepositionScreenState();
}

class _RepositionScreenState extends State<RepositionScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _serialController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;
  Timer _timer;
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();
  bool loading = true;
  int _start = 5;

  @override
  // void initState() {
    // super.initState();
    // startTimer();
    // _homeWidgetBloc.currentRequestTypeIn.add("Reposição");
    // _requestsBloc.getPedidosRepoList(2);
    // _nameController = TextEditingController();
    // _numberController = TextEditingController();
    // _serialController = TextEditingController();
    // _birthdayController = MaskedTextController(
    //   mask: '00/00/0000',
    // );
  // }

  _pacienteInfo(BuildContext context) {
    Dialogs.patientControlInfo(context,   
    onTap: () {
      Modular.to.pop();
    },
    message: '\nControle de Pacientes, Tem o objetivo de organizar, Via APP de forma dinamica os cuidados com o usuario de L.C. do cliente, Sugerindo uma data para reavaliação e reposição  das L.C., Baseado na quantidade e no regime de uso e data de entrega das L.C. ao paciente. Voce pode inserir e controlar L.C. de qualquer fabricante, As L.C. solicitadas na Central Oftalmica nas quais você identifica o paciente (Nome, Numero, Etc), Entrará automaticamente neste controle a Central oftalmica não utiliza estes dados para qualquer finalidade, Eles podem ser copiados, Editados ou excluidos a qualquer momento a criterio exclusivo do cliente.');
  }

  _onShowRequest(int id, PedidoModel pedidoData, bool reposicao) {
    Modular.to.pushNamed('/requests/$id', arguments: {
      "pedidoData": pedidoData,
      "reposicao": reposicao,
    });
  }

  Widget _showPedido(
      BuildContext context, List<PedidoModel> _requests, int index) {
    return ListTileMoreCustomizable(
      contentPadding: const EdgeInsets.all(0),
      onTap: (value) {
        // String currentType = _homeWidgetBloc.currentRequestType;
        // bool reposicao = false;
        // if (currentType == "Reposição") {
        //   reposicao = true;
        // }
        // _onShowRequest(
        //     _requests[index].numeroPedido, _requests[index], reposicao);
      },
      horizontalTitleGap: 10,
      leading: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xffECECEC),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '09/04/2024',
          // Helper.dateToMonth(
          //   _requests[index].dataInclusao,
          // ).substring(0, 8),
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                fontSize: 14,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Pedido: 2651',
                // 'Pedido ${_requests[index].numeroPedido}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Valor',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'R\$ 20,00',
                    // 'R\$ ${Helper.intToMoney(_requests[index].valor)}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14,
                        ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).accentColor,
                  )
                ],
              ),
            ],
          ),
          Text(
            'Previsão de entrega: 17/04/2024',
            // 'Previsão de entrega: ${Helper.sqlToDate(_requests[index].dataInclusao)}',
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.black26,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _showPedidoReposicao(
      BuildContext context, List<PedidoModel> _requests, int index) {
    return Column(
      children: [
        Row(children: [
          Text('Copiar'),
          SizedBox(width: 10,),
          Text('Editar'),
          SizedBox(width: 10,),
          Text('Excluir')
        ],),
        ListTileMoreCustomizable(
          contentPadding: const EdgeInsets.all(0),
          onTap: (value) {
            // String currentType = _homeWidgetBloc.currentRequestType;
            // bool reposicao = false;
            // if (currentType == "Reposição") {
            //   reposicao = true;
            // }
            // _onShowRequest(
            //     _requests[index].numeroPedido, _requests[index], reposicao);
          },
          horizontalTitleGap: 10,
          leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffECECEC),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '09/04/2024',
              // Helper.dateToMonth(
              //   _requests[index].dataInclusao,
              // ).substring(0, 8),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Cleiton Meireles',
                    // '${_requests[index].paciente}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Repor até',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido n°: 2651',
                    // 'Pedido ${_requests[index].numeroPedido}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: Text(
                        '15/04/2024',
                        // '${Helper.sqlToDate(_requests[index].dataReposicao)}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 16,
                            ),
                      ))
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Column(
              children: [
                Text('034C'),
                Text('070C')
              ],
            ),
            SizedBox(width: 15,),
            Column(
              children: [
                    Text('OD: Grau: -2.0 Eixo: 180', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),),
                    Text('OE: Grau: -0.5 Eixo: 150', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),)
                  ],
              ),
            SizedBox(width: 15,),
            Column(
              children: [
                FittedBox(child: Text('Quantidade: 10')),
                Text('Quantidade: 3')
              ],
            )
          ],
        ),
          SizedBox(height: 30,)
      ],
    );
  }

  Widget _showPedidoReposicao2(
      BuildContext context, List<PedidoModel> _requests, int index) {
    return Column(
      children: [
        Row(children: [
          Text('Copiar'),
          SizedBox(width: 10,),
          Text('Editar'),
          SizedBox(width: 10,),
          Text('Excluir')
        ],),
        ListTileMoreCustomizable(
          contentPadding: const EdgeInsets.all(0),
          onTap: (value) {
            // String currentType = _homeWidgetBloc.currentRequestType;
            // bool reposicao = false;
            // if (currentType == "Reposição") {
            //   reposicao = true;
            // }
            // _onShowRequest(
            //     _requests[index].numeroPedido, _requests[index], reposicao);
          },
          horizontalTitleGap: 10,
          leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffECECEC),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '09/04/2024',
              // Helper.dateToMonth(
              //   _requests[index].dataInclusao,
              // ).substring(0, 8),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Paulo Maidera',
                    // '${_requests[index].paciente}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Repor até',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido n°: 2652',
                    // 'Pedido ${_requests[index].numeroPedido}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: Text(
                        '29/04/2024',
                        // '${Helper.sqlToDate(_requests[index].dataReposicao)}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 16,
                            ),
                      ))
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Column(
              children: [
                Text('060C'),
                Text('061C')
              ],
            ),
            SizedBox(width: 15,),
            Column(
              children: [
                    Text('OD: Grau: +2.0 Eixo: 160', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),),
                    Text('OE: Grau: +1.0 Eixo: 180', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),)
                  ],
              ),
            SizedBox(width: 15,),
            Column(
              children: [
                FittedBox(child: Text('Quantidade: 6')),
                Text('Quantidade: 10')
              ],
            )
          ],
        ),
          SizedBox(height: 30,)
      ],
    );
  }

  Widget _showPedidoReposicao3(
      BuildContext context, List<PedidoModel> _requests, int index) {
    return Column(
      children: [
        Row(children: [
          Text('Copiar'),
          SizedBox(width: 10,),
          Text('Editar'),
          SizedBox(width: 10,),
          Text('Excluir')
        ],),
        ListTileMoreCustomizable(
          contentPadding: const EdgeInsets.all(0),
          onTap: (value) {
            // String currentType = _homeWidgetBloc.currentRequestType;
            // bool reposicao = false;
            // if (currentType == "Reposição") {
            //   reposicao = true;
            // }
            // _onShowRequest(
            //     _requests[index].numeroPedido, _requests[index], reposicao);
          },
          horizontalTitleGap: 10,
          leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffECECEC),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '09/04/2024',
              // Helper.dateToMonth(
              //   _requests[index].dataInclusao,
              // ).substring(0, 8),
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 14,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Alberto Bittencourt',
                    // '${_requests[index].paciente}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Repor até',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      )
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pedido n°: 2653',
                    // 'Pedido ${_requests[index].numeroPedido}',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: Text(
                        '17/04/2024',
                        // '${Helper.sqlToDate(_requests[index].dataReposicao)}',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontSize: 16,
                            ),
                      ))
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Column(
              children: [
                Text('033C'),
                Text('050C')
              ],
            ),
            SizedBox(width: 15,),
            Column(
              children: [
                    Text('OD: Grau: -1.0 Eixo: 100', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),),
                    Text('OE: Grau: -0.25 Eixo: 110', style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.black26,
                          fontSize: 14,
                        ),)
                  ],
              ),
            SizedBox(width: 15,),
            Column(
              children: [
                FittedBox(child: Text('Quantidade: 5')),
                Text('Quantidade: 2')
              ],
            )
          ],
        ),
          SizedBox(height: 30,)
      ],
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start <= 1) {
                setState(() {
                  loading = false;
                });
                timer.cancel();
              } else {
                _start = _start - 1;
              }
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    _nameController.dispose();
    _numberController.dispose();
    _birthdayController.dispose();
    _serialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Paciente'),
        centerTitle: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Controle de pacientes',
                        style: Theme.of(context).textTheme.headline5,
                        // textScaleFactor: 1.25,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.help_outline,
                        size: 30,
                      ),
                      onPressed: () {
                        _pacienteInfo(context);
                      },
                    ),
                  ],
                )),
            Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                  stream: _requestsBloc.pedidoReposicaoStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<PedidoModel> _requests = snapshot.data.list ?? [];

                    // if (_requests.isEmpty) {
                    //   return Center(
                    //     child:
                    //         Text('Não há pacientes a serem visualizados'),
                    //   );
                    // }
                    return ListView.separated(
                      // padding: const EdgeInsets.all(20),
                      itemCount: 1,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
                      itemBuilder: (context, index) {
                        // String currentType =
                        //     _homeWidgetBloc.currentRequestType;
                        // if (currentType == "Reposição") {
                        return Column(
                          children: [
                            _showPedidoReposicao(
                                context, _requests, index),
                                _showPedidoReposicao2(
                                context, _requests, index),
                                _showPedidoReposicao3(
                                context, _requests, index),
                          ],
                        );
                        // }
                        // return _showPedido(context, _requests, index);
                      },
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}
