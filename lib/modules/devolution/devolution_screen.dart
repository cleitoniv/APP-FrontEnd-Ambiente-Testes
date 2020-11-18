import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:central_oftalmica_app_cliente/blocs/devolution_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

int numItem = 0;

class DevolutionScreen extends StatefulWidget {
  @override
  _DevolutionScreenState createState() => _DevolutionScreenState();
}

class _DevolutionScreenState extends State<DevolutionScreen> {
  DevolutionWidgetBloc _devolutionWidgetBloc =
      Modular.get<DevolutionWidgetBloc>();
  TextEditingController _serialController;

  StreamSubscription errorHandler;

  _onChangeDevolutionType(value) {
    _devolutionWidgetBloc.setTipoTroca(value);
    _devolutionWidgetBloc.devolutionTypeIn.add(value);
  }

  _showDialog(String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text(content),
          actions: [
            RaisedButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Modular.to.pop();
                })
          ],
        );
      },
    );
  }

  _onAddProduct() async {
    if (_devolutionWidgetBloc.currentProductList.list == null) {
      _devolutionWidgetBloc.addProduct(_serialController.text);
    } else {
      final prod = _devolutionWidgetBloc.currentProductList.list;

      final hasItem = prod.firstWhere(
          (e) => e.numSerie == _serialController.text,
          orElse: () => null);
      if (hasItem?.numSerie == null) {
        _devolutionWidgetBloc.addProduct(_serialController.text);
        Timer(Duration(seconds: 2), () {
          if (_devolutionWidgetBloc.productError["message"] != null) {
            Dialogs.error(this.context,
                title: "Ops...",
                subtitle: _devolutionWidgetBloc.productError["message"],
                buttonText: "OK", onTap: () {
              Navigator.pop(this.context);
            });
          }
        });
      } else {
        _showDialog('Atenção', 'Produto já está na lista.');
      }
    }
  }

  _onSubmit() async {
    _devolutionWidgetBloc.confirmDevolution();
  }

  _qrCodeRead() async {
    ScanResult qrCode = await BarcodeScanner.scan();
    _devolutionWidgetBloc.addProduct(qrCode.rawContent);
  }

  _removeItem(String numSerie) {
    final prod = _devolutionWidgetBloc.currentProductList.list;

    final hasItem =
        prod.firstWhere((e) => e.numSerie == numSerie, orElse: () => null);
    if (hasItem?.numSerie != null) {
      _devolutionWidgetBloc.currentProductList.list
          .removeWhere((element) => element.numSerie == numSerie);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    errorHandler = _devolutionWidgetBloc.productErrorStream.listen((event) {
      if (event != "clear") {
        Dialogs.error(this.context,
            title: "Ops...",
            subtitle: event["message"],
            buttonText: "OK", onTap: () {
          Navigator.pop(this.context);
        });
        _devolutionWidgetBloc.productErrorSink.add("clear");
      }
    });
    _serialController = TextEditingController();
    _devolutionWidgetBloc.resetPreDevolucao();
  }

  @override
  void dispose() {
    _serialController.dispose();
    errorHandler.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int i = -1;
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
            suffixIcon: Padding(
                padding: const EdgeInsets.all(15),
                child: IconButton(
                  icon: Icon(FlutterIcons.qrcode_scan_mco, color: Colors.green),
                  onPressed: _qrCodeRead,
                )),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 30),
          Text(
            'Produtos Adicionados',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          StreamBuilder(
            stream: _devolutionWidgetBloc.productsListStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return Center(child: Text("Nao há produtos adicionados."));
              }
              // return Container();
              return Container(
                  width: double.infinity,
                  height: 100,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.list.map<Widget>((e) {
                        return Row(
                          children: [
                            Container(
                              width: 300,
                              height: 90,
                              child: ListTileMoreCustomizable(
                                contentPadding: const EdgeInsets.all(5),
                                leading: CachedNetworkImage(
                                  imageUrl: "${e.imageUrl}",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                title: Text("'${e.title}'"),
                                subtitle: Text("NF ${e.nf}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontSize: 15)),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _removeItem(e.numSerie);
                              },
                            )
                          ],
                        );
                      }).toList()));
              // print(snapshot.data.list);
              // return Column(
              //   children: snapshot.data.list.map<Widget>((e) {
              //     return ListTileMoreCustomizable(
              //       contentPadding: const EdgeInsets.all(5),
              //       leading: CachedNetworkImage(
              //         imageUrl: e.imageUrl,
              //         width: 80,
              //         height: 80,
              //         fit: BoxFit.cover,
              //       ),
              //       title: Text("${e.title}"),
              //     );
              //   }).toList(),
              // );
            },
          ),
          SizedBox(height: 20),
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
