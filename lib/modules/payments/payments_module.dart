import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/payments/payments_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaymentsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<PaymentsWidgetBloc>(),
        ),
      ];

  @override
  List<Router> get routers => [
        Router('/', child: (_, args) => PaymentsScreen()),
      ];
}
