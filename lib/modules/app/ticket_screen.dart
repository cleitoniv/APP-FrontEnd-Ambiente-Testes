import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/helper/dialogs.dart';
import 'package:central_oftalmica_app_cliente/helper/helper.dart';
import 'package:central_oftalmica_app_cliente/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TicketScreen extends StatefulWidget {
  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _formKey = GlobalKey<FormState>();
  Stream<Map> _data;
  TextEditingController _titleController;
  TextEditingController _messageController;
  TicketBloc _ticketBloc = Modular.get<TicketBloc>();
  bool _isLoading;

  _openTicket() async {
    setState(() {
      _isLoading = true;
    });
    await _ticketBloc.ticket();
    setState(() {
      _isLoading = false;
    });

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
                TextFieldWidget(
                  validator: Helper.lengthValidator,
                  labelText: 'Titulo',
                  controller: _titleController,
                  prefixIcon: Icon(
                    Icons.title,
                    color: Color(0xffa1a1a1),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: TextFormField(
                    validator: Helper.lengthValidator,
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
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                          } else {
                            _openTicket();
                          }
                        },
                        child: Text(
                          'Enviar',
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
