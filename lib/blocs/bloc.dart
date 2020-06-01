import 'package:flutter_modular/flutter_modular.dart';

abstract class Bloc<Model> extends Disposable {
  Sink get indexIn => throw UnimplementedError();
  Stream<List<Model>> get indexOut => throw UnimplementedError();

  Sink get showIn => throw UnimplementedError();
  Stream<Model> get showOut => throw UnimplementedError();

  Sink get storeIn => throw UnimplementedError();
  Stream<String> get storeOut => throw UnimplementedError();

  Sink get updateIn => throw UnimplementedError();
  Stream<String> get updateOut => throw UnimplementedError();

  Sink get destroyIn => throw UnimplementedError();
  Stream<String> get destroyOut => throw UnimplementedError();
}
