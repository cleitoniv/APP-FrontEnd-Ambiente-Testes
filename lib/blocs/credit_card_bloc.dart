import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/credit_card_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/credit_card_repository.dart';
import 'package:rxdart/subjects.dart';

class CreditCardBloc extends Bloc<CreditCardModel> {
  CreditCardRepository repository;

  CreditCardBloc(this.repository);

  BehaviorSubject _indexController = BehaviorSubject.seeded(null);
  @override
  Sink get indexIn => _indexController.sink;
  @override
  Stream<List<CreditCardModel>> get indexOut =>
      _indexController.stream.asyncMap(
        (event) => repository.index(),
      );

  BehaviorSubject _storeController = BehaviorSubject.seeded(null);
  @override
  Sink get storeIn => _storeController.sink;
  @override
  Stream<String> get storeOut => _storeController.stream.asyncMap(
        (event) => repository.store(model: event),
      );

  @override
  void dispose() {
    _indexController.close();
    _storeController.close();
  }
}
