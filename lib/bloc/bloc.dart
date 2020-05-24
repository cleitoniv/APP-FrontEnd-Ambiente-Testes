abstract class Bloc<Model> {
  Sink get indexIn => throw UnimplementedError();
  Stream<List<Model>> get indexOut => throw UnimplementedError();

  Sink get showIn => throw UnimplementedError();
  Stream<Model> get showOut => throw UnimplementedError();

  Sink get storeIn => throw UnimplementedError();
  Stream<String> get storeOut => throw UnimplementedError();

  Sink get updateIn => throw UnimplementedError();
  Stream<String> get updateOut => throw UnimplementedError();

  Sink get deleteIn => throw UnimplementedError();
  Stream<String> get deleteOut => throw UnimplementedError();
}
