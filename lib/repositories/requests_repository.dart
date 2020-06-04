import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';

class RequestsRepository extends Repository<RequestModel> {
  Dio dio;

  RequestsRepository(this.dio);

  @override
  Future<List<RequestModel>> index({
    Map<String, dynamic> filter,
  }) async {
    try {
      Response response = await dio.get(
        '/requests',
        queryParameters: filter,
      );

      return (response.data as List)
          .map(
            (e) => RequestModel.fromJson(e),
          )
          .toList();
    } catch (error) {
      return null;
    }
  }
}
