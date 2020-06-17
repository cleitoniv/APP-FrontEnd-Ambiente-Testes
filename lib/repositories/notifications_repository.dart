import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';

class NotificationsRepository extends Repository<NotificationModel> {
  Dio dio;

  NotificationsRepository(this.dio);

  @override
  Future<List<NotificationModel>> index() async {
    try {
      Response response = await dio.get(
        '/notifications',
      );

      return (response.data as List)
          .map(
            (e) => NotificationModel.fromJson(e),
          )
          .toList();
    } catch (error) {
      return null;
    }
  }
}
