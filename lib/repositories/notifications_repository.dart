import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsList {
  bool isLoading;
  bool isEmpty;
  List<NotificationModel> list;

  NotificationsList({this.isLoading, this.isEmpty, this.list});
}

class NotificationsRepository extends Repository<NotificationModel> {
  Dio dio;

  NotificationsRepository(this.dio);

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<NotificationsList> fetchNotifications() async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.get("/api/cliente/notifications",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      List<NotificationModel> list =
          response.data["data"]["notifications"].map<NotificationModel>((e) {
        return NotificationModel.fromJson(e);
      }).toList();

      return NotificationsList(
          isLoading: false, isEmpty: list.length <= 0, list: list);
    } catch (error) {
      return NotificationsList(isLoading: false, isEmpty: true);
    }
  }

  Future<bool> readNotification(int id) async {
    FirebaseUser user = await _auth.currentUser();
    IdTokenResult idToken = await user.getIdToken();

    try {
      Response response = await dio.put("/api/cliente/read_notification/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${idToken.token}",
            "Content-Type": "application/json"
          }));
      return true;
    } catch (error) {
      return false;
    }
  }

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
