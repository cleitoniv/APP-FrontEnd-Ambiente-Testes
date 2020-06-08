import 'package:central_oftalmica_app_cliente/blocs/bloc.dart';
import 'package:central_oftalmica_app_cliente/models/notification_model.dart';
import 'package:central_oftalmica_app_cliente/repositories/notifications_repository.dart';
import 'package:rxdart/subjects.dart';

class NotificationBloc extends Bloc<NotificationModel> {
  NotificationsRepository repository;

  NotificationBloc(this.repository);

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
    _indexController.close();
  }
}
