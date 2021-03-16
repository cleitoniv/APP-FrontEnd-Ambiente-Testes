import 'package:central_oftalmica_app_cliente/repositories/credits_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';

class ExtractWidgetBloc extends Disposable {
  CreditsRepository repository;

  ExtractWidgetBloc({this.repository});

  BehaviorSubject _extractTypeController = BehaviorSubject.seeded('Financeiro');
  Sink get extractTypeIn => _extractTypeController.sink;
  Stream<String> get extractTypeOut => _extractTypeController.stream.map(
        (event) => event,
      );

  void fetchExtratoFinanceiro() async {
    extratoFinanceiroSink
        .add(ExtratoFinanceiro(isLoading: true, isEmpty: false));
    ExtratoFinanceiro extrato = await repository.fetchExtrato();
    extratoFinanceiroSink.add(extrato);
  }

  void fetchExtratoProduto() async {
    extratoProdutoSink.add(ExtratoProduto(isLoading: true, isEmpty: false));
    ExtratoProduto extrato = await repository.fetchExtratoProduto();
    extratoProdutoSink.add(extrato);
  }

  BehaviorSubject _currentPage =
      BehaviorSubject.seeded({'type': "Financeiro", 'page': 0});
  Sink get currentPageSink => _currentPage.sink;
  Map<String, dynamic> get currentPageValue => _currentPage.value;

  BehaviorSubject _extratoFinanceiroController = BehaviorSubject();
  Sink get extratoFinanceiroSink => _extratoFinanceiroController.sink;
  Stream get extratoFinanceiroStream => _extratoFinanceiroController.stream;

  BehaviorSubject _extratoProdutoController = BehaviorSubject();
  Sink get extratoProdutoSink => _extratoProdutoController.sink;
  Stream get extratoProdutoStream => _extratoProdutoController.stream;

  @override
  void dispose() {
    _extratoFinanceiroController.close();
    _extratoProdutoController.close();
    _extractTypeController.close();
    _currentPage.close();
  }
}
