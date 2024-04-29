import 'package:central_oftalmica_app_cliente/repositories/payment_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class PaymentsWidgetBloc extends Disposable {
  PaymentRepository repository;

  PaymentsWidgetBloc({this.repository});

  BehaviorSubject _paymentTypeController = BehaviorSubject.seeded('À Vencer');
  Sink get paymentTypeIn => _paymentTypeController.sink;
  Stream<String> get paymentTypeOut => _paymentTypeController.stream.map(
        (event) => event,
      );

  void fetchPayments(String filtro) async {
    paymentsListSink.add(PaymentsList(isLoading: true));
    PaymentsList list = await repository.fetchPayments(filtro);
    paymentsListSink.add(list);
  }

  void fetchPagamentos() async {
    // pagamentosListSink.add(PagamentosList(isLoading: true));
    PagamentosList list = await repository.fetchPagamentos();
    pagamentosListSink.add(list);
  }

  BehaviorSubject _paymentsFilter = BehaviorSubject.seeded(0);
  Sink get paymentsFilter => _paymentsFilter.sink;
  int get currentFilter => _paymentsFilter.value;

  BehaviorSubject _pagamentosListController = BehaviorSubject();
  Sink get pagamentosListSink => _pagamentosListController.sink;
  Stream get pagamentosListStream => _pagamentosListController.stream;

  BehaviorSubject _paymentsListController = BehaviorSubject();
  Sink get paymentsListSink => _paymentsListController.sink;
  Stream get paymentsListStream => _paymentsListController.stream;

  @override
  void dispose() {
    _pagamentosListController.close();
    _paymentsFilter.close();
    _paymentsListController.close();
    _paymentTypeController.close();
  }
}
