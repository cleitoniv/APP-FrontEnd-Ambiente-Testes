import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/ticket_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';

class TicketBloc extends Bloc<TicketModel> {
  UserRepository repository;

  TicketBloc(this.repository);

  Future<TicketModel> ticket() async {
    return repository.openTicket();
  }

  @override
  void dispose() {}
}
