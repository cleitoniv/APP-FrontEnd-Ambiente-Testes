import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/request_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/models/pedido_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class RepositionScreen extends StatefulWidget {
  @override
  _RepositionScreenState createState() => _RepositionScreenState();
}

class _RepositionScreenState extends State<RepositionScreen> {
  UserBloc _userBloc = Modular.get<UserBloc>();
  AuthBloc _authBloc = Modular.get<AuthBloc>();
  List<Map> _data;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;
  TextEditingController _serialController;
  TextEditingController _numberController;
  MaskedTextController _birthdayController;

  RequestsBloc _requestsBloc = Modular.get<RequestsBloc>();
  HomeWidgetBloc _homeWidgetBloc = Modular.get<HomeWidgetBloc>();

  _onSubmitDialog() {
    Modular.to.pop();
    Modular.to.pop();
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> params = {
        'num_serie': _serialController.text,
        'paciente': _nameController.text,
        'num_pac': _numberController.text,
        'dt_nas_pac': _birthdayController.text,
      };

      PointsResult _result = await _userBloc.addPoints(params);
      if (_result.isValid) {
        Dialogs.success(
          context,
          subtitle: 'Pontos adicionados com sucesso!',
          buttonText: 'Ir para os Meus Pontos',
          onTap: _onSubmitDialog,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _homeWidgetBloc.currentRequestTypeIn.add("Reposição");
    _requestsBloc.getPedidosList(2);
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _serialController = TextEditingController();
    _birthdayController = MaskedTextController(
      mask: '00/00/0000',
    );
    _data = [
      {
        'labelText': 'Nome do paciente',
        'icon': Icons.person,
        'controller': _nameController,
      },
      {
        'labelText': 'Número de Referência do Paciente',
        'icon': MaterialCommunityIcons.numeric,
        'controller': _numberController,
      },
      {
        'labelText': 'Data de nascimento',
        'icon': MaterialCommunityIcons.cake_layered,
        'controller': _birthdayController,
      },
    ];
  }

  _pacienteInfo(BuildContext context) {
    Dialogs.pacienteInfo(context, onTap: () {
      Modular.to.pop();
    },
        title: "Pontuação",
        subtitle:
            '''Inserindo os dados do seu paciente referente ao produto, voce recebe pontos que podem ser convertidos em créditos para compras futuras!''');
  }

  _onShowRequest(int id, PedidoModel pedidoData, bool reposicao) {
    Modular.to.pushNamed('/requests/${id}',
        arguments: {"pedidoData": pedidoData, "reposicao": reposicao});
  }

  Widget _showPedido(
      BuildContext context, List<PedidoModel> _requests, int index) {
    return ListTileMoreCustomizable(
      contentPadding: const EdgeInsets.all(0),
      onTap: (value) {
        String currentType = _homeWidgetBloc.currentRequestType;
        bool reposicao = false;
        if (currentType == "Reposição") {
          reposicao = true;
        }
        _onShowRequest(
            _requests[index].numeroPedido, _requests[index], reposicao);
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
          Helper.dateToMonth(
            _requests[index].dataInclusao,
          ).substring(0, 8),
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
                'Pedido ${_requests[index].numeroPedido}',
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
                    'R\$ ${Helper.intToMoney(_requests[index].valor)}',
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
            'Previsão de entrega: ${Helper.sqlToDate(_requests[index].dataInclusao)}',
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
    return ListTileMoreCustomizable(
      contentPadding: const EdgeInsets.all(0),
      onTap: (value) {
        String currentType = _homeWidgetBloc.currentRequestType;
        bool reposicao = false;
        if (currentType == "Reposição") {
          reposicao = true;
        }
        _onShowRequest(
            _requests[index].numeroPedido, _requests[index], reposicao);
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
          Helper.dateToMonth(
            _requests[index].dataInclusao,
          ).substring(0, 8),
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
                '${_requests[index].paciente}',
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
                'Pedido ${_requests[index].numeroPedido}',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.black26,
                      fontSize: 14,
                    ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    '${Helper.sqlToDate(_requests[index].dataReposicao)}',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 16,
                        ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
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
        title: Text('Adicionar Pontos'),
        centerTitle: false,
      ),
      body: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Controle de pacientes',
                          style: Theme.of(context).textTheme.headline5,
                          textAlign: TextAlign.center,
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
                SizedBox(height: 10),
                Text(
                  'Digite o número de série do produto, nome, número de referência (opcional) e data de nascimento do paciente que receberá e acumule pontos!',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: StreamBuilder(
                      stream: _requestsBloc.pedidoStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<PedidoModel> _requests = snapshot.data.list ?? [];
                        return ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: _requests.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                          itemBuilder: (context, index) {
                            String currentType =
                                _homeWidgetBloc.currentRequestType;
                            if (currentType == "Reposição") {
                              return _showPedidoReposicao(
                                  context, _requests, index);
                            }
                            return _showPedido(context, _requests, index);
                          },
                        );
                      },
                    ))
              ],
            ),
          )),
    );
  }
}
