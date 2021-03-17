import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descricaoController;
  String _categoria;
  TicketBloc _ticketBloc = Modular.get<TicketBloc>();
  bool _isLoading;

  _openTicket() async {
    _ticketBloc.ticketIn
        .add({'descricao': _descricaoController.text, 'categoria': _categoria});
    var _data = _ticketBloc.getTicket;
    await _ticketBloc.ticket(_data);
    return Dialogs.success(context,
        subtitle: 'Ticket enviado com sucesso!',
        buttonText: 'Ok',
        onTap: () => Modular.to.pushNamed(
              '/home/0',
            ));
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _descricaoController = TextEditingController(text: '');
    _categoria = 'Teste 1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Abra um Ticket'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                StreamBuilder<Map>(builder: (context, snapshot) {
                  return DropdownWidget(
                      prefixIcon: Icon(Icons.info_outline),
                      items: ['Teste 1', 'Teste2'],
                      currentValue: _categoria,
                      labelText: 'Categoria do problema',
                      onChanged: (value) {
                        setState(() {
                          _categoria = value;
                        });
                      });
                }),
                SizedBox(height: 50),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(120)],
                    controller: _descricaoController,
                    validator: (String text) =>
                        Helper.lengthValidatorHelpDesk(text),
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.text_format, color: Color(0xffa1a1a1)),
                        labelText: 'Conte-nos o que aconteceu'),
                    maxLines: 4,
                  ),
                ),
                SizedBox(height: 50),
                _isLoading == false
                    ? RaisedButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            await _openTicket();
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text(
                          'Enviar Ticket',
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          )),
    );
  }
}
