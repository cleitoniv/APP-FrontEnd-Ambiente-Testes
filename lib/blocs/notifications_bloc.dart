import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/notifications_repository.dart';
import 'package:rxdart/subjects.dart';

class NotificationBloc extends Bloc<NotificationModel> {
  NotificationsRepository repository;

  NotificationBloc(this.repository);

  void fetchNotifications() async {
    notificationsSink.add(NotificationsList(isLoading: true));
    NotificationsList list = await repository.fetchNotifications();
    notificationsSink.add(list);
  }

  Future<bool> readNotification(int id) async {
    return repository.readNotification(id);
  }

  BehaviorSubject _notificationsController = BehaviorSubject();
  Sink get notificationsSink => _notificationsController.sink;
  Stream get notificationsStream => _notificationsController.stream;

  BehaviorSubject _indexController = BehaviorSubject.seeded(null);
  @override
  Sink get indexIn => _indexController.sink;
  @override
  Stream<List<NotificationModel>> get indexOut =>
      _indexController.stream.asyncMap(
        (event) => repository.index(),
      );

  @override
  void dispose() {
    _notificationsController.close();
    _indexController.close();
  }
}
