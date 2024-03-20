import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/models/product_model.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/cart.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/pagamento_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/finish_payment_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product_grid.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'credito_financeiro_screen.dart';

class CreditoFinanceiroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => i.get<HomeWidgetBloc>()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => CreditoFinanceiroScreen(),
    ),
    ChildRoute('/pagamento', child: (_, args) => CreditoPagamentoScreen()),
    ChildRoute('/produto', child: (_, args) => CreditProductGridScreen()),
    ChildRoute(
      '/produto/:id',
      child: (_, args) => ProductDetailScreen(id: 0),
      // ProductDetailScreen(id: 0, product: args.data, offers: args.data),
    ),
    ChildRoute(
      '/cart',
      child: (_, args) => CreditCartScreen(),
    ),
    ChildRoute(
      '/finishPayment',
      child: (_, args) => FinishPayment(),
    )
  ];
}
