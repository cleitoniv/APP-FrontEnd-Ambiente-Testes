abstract class Repository {
  Future create({Map data}) async {}
  Future delete({int id}) async {}
  Future index() async {}
  Future show({int id}) async {}
  Future update({
    int id,
    Map data,
  }) async {}
}
