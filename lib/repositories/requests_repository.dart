import 'package:central_oftalmica_app_cliente/models/request_details_model.dart';
import 'package:central_oftalmica_app_cliente/models/request_model.dart';
import 'package:dio/dio.dart';

class RequestsRepository {
  Dio dio;

  RequestsRepository(this.dio);

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

  Future<RequestDetailsModel> show({int id}) async {
    try {
      Response response = await dio.get(
        '/requests/$id/details',
      );

      return RequestDetailsModel.fromJson(
        response.data,
      );
    } catch (error) {
      return null;
    }
  }
}
