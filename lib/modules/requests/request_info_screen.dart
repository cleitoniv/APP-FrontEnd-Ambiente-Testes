import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/product_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_details_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RequestInfoScreen extends StatelessWidget {
  int id;
  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  ProductBloc _productBloc = Modular.get<ProductBloc>();

  RequestInfoScreen({
    this.id,
  }) {
    _requestsBloc.showIn.add(
      this.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do pedido'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          Text(
            'Informações do Pedido',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          StreamBuilder<RequestDetailsModel>(
              stream: _requestsBloc.showOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final _request = snapshot.data;
                _productBloc.showIn.add(
                  _request.productId,
                );

                return Table(
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Pedido nº',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Último Pedido',
                          style: Theme.of(context).textTheme.headline5.copyWith(
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
                          '${_request.id}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          Helper.sqlToDate(_request.lastRequest),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )
                  ],
                );
              }),
          SizedBox(height: 20),
          Text(
            'Produtos Comprados',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  fontSize: 18,
                ),
            textAlign: TextAlign.center,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            padding: const EdgeInsets.all(20),
            color: Color(0xffF1F1F1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<RequestDetailsModel>(
                    stream: _requestsBloc.showOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final _request = snapshot.data;
                      return Table(
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
                                _request.owner,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${_request.referenceId}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                Helper.sqlToDate(_request.birthday),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ],
                      );
                    }),
                SizedBox(height: 20),
                StreamBuilder<ProductModel>(
                  stream: _productBloc.showOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final _product = snapshot.data;
                    return ListTileMoreCustomizable(
                      contentPadding: const EdgeInsets.all(0),
                      horizontalTitleGap: 10,
                      leading: CachedNetworkImage(
                        imageUrl: _product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        _product.title,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      subtitle: StreamBuilder<RequestDetailsModel>(
                        stream: _requestsBloc.showOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }

                          final _request = snapshot.data;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Qnt. ${_request.quantity}',
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
                                backgroundColor: Color(0xff707070),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Color(0xffF1F1F1),
                                  size: 15,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                Helper.buyTypeBuild(
                                    context, _request.type)['title'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                      trailing: StreamBuilder<RequestDetailsModel>(
                        stream: _requestsBloc.showOut,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return Text(
                            'R\$ ${Helper.intToMoney(snapshot.data.value)}',
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 16,
                                    ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                ListTileMoreCustomizable(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  horizontalTitleGap: 0,
                  leading: Image.asset(
                    'assets/icons/info.png',
                    width: 25,
                    height: 25,
                  ),
                  title: StreamBuilder<RequestDetailsModel>(
                    stream: _requestsBloc.showOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Text.rich(
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
                              text: snapshot.data.adviceTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  height: 50,
                  thickness: 0.3,
                  color: Colors.black38,
                ),
                Text(
                  'Parâmetros',
                  style: Theme.of(context).textTheme.headline5.copyWith(
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
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Olho direito',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontSize: 14,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Grau Esférico',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.leftEye.sphericalDegree / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    Text(
                      'Grau Esférico',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.rightEye.sphericalDegree / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Cilíndro',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.leftEye.cylinder / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    Text(
                      'Cilíndro',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.rightEye.cylinder / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Eixo',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.leftEye.axis / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    Text(
                      'Eixo',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                    ),
                    StreamBuilder<RequestDetailsModel>(
                      stream: _requestsBloc.showOut,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Text(
                          '${snapshot.data.rightEye.axis / 100}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
                Divider(
                  height: 50,
                  thickness: 0.2,
                  color: Colors.black38,
                ),
                StreamBuilder<RequestDetailsModel>(
                    stream: _requestsBloc.showOut,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      final _request = snapshot.data;
                      return Table(
                        children: [
                          TableRow(
                            children: [
                              Text(
                                'Previsão de Entrega',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Text(
                                'Total + Frete',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                Helper.sqlToDate(_request.deliveryForecast),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              ),
                              Text(
                                'R\$ ${Helper.intToMoney(_request.value)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                      fontSize: 14,
                                    ),
                              )
                            ],
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
