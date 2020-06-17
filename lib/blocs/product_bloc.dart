import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/product_repository.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc implements Bloc<ProductModel> {
  ProductRepository repository;

  ProductBloc(this.repository);

  @override
  Sink get destroyIn => throw UnimplementedError();

  @override
  Stream<String> get destroyOut => throw UnimplementedError();

  BehaviorSubject _indexController = BehaviorSubject.seeded(null);
  @override
  Sink get indexIn => _indexController.sink;

  @override
  Stream<List<ProductModel>> get indexOut => _indexController.stream.asyncMap(
        (event) => repository.index(),
      );

  @override
  Sink get showIn => throw UnimplementedError();

  @override
  Stream<ProductModel> get showOut => throw UnimplementedError();

  @override
  Sink get storeIn => throw UnimplementedError();

  @override
  Stream<String> get storeOut => throw UnimplementedError();

  @override
  Sink get updateIn => throw UnimplementedError();

  @override
  Stream<String> get updateOut => throw UnimplementedError();

  @override
  void dispose() {
    _indexController.close();
  }
}
