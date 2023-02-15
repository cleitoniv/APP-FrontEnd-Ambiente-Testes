import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class CreditoFinanceiro {
  int valor;
  int installmentCount;
  int desconto;
  CreditoFinanceiro({this.valor, this.installmentCount, this.desconto});

  void set installment(int installment) {
    installmentCount = installment;
  }
}

class CreditoFinanceiroBloc extends Disposable {
  CreditsRepository repository;

  CreditoFinanceiroBloc({this.repository});

  BehaviorSubject _creditoFinanceiroController = BehaviorSubject();
  Sink get creditoFinaceiroSink => _creditoFinanceiroController.sink;
  Stream get creditoFinaceiroStream => _creditoFinanceiroController.stream;
  get creditoFinanceiroValue => _creditoFinanceiroController.value;

  Future<bool> pagamento(
      CreditoFinanceiro credit, String token, bool isBoleto) {
    return repository.creditoFinanceiroPagamento(credit, token, isBoleto);
  }

  @override
  void dispose() {
    _creditoFinanceiroController.close();
  }
}
