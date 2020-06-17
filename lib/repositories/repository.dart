abstract class Repository<Model> {
  Future<String> store({Model model}) async {}
  Future<String> delete({int id}) async {}
  Future<List<Model>> index() async {}
  Future<Model> show({int id}) async {}
  Future<String> update({int id, Model model}) async {}
}
