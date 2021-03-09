import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/ticket_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/app/ticket_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/cart.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/pagamento_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/finish_payment_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product_grid.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TicketModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<HomeWidgetBloc>()),
        Bind(
          (i) => i.get<TicketBloc>(),
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => TicketScreen(),
        ),
      ];
}
