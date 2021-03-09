import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/ticket_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class TicketBloc extends Bloc<TicketModel> {
  UserRepository repository;

  TicketBloc(this.repository);

  Future<TicketModel> ticket(data) async {
    return repository.openTicket(data);
  }

  get getTicket => _ticketController.value;

  // ignore: close_sinks
  BehaviorSubject _ticketController = BehaviorSubject();
  Sink get ticketIn => _ticketController.sink;
  Stream get ticketOut => _ticketController.stream;

  @override
  void dispose() {}
}
