import 'package:central_oftalmica_app_cliente/blocs/payments_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/payments/payments_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaymentsModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => i.get<PaymentsWidgetBloc>(),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => PaymentsScreen()),
  ];
}
