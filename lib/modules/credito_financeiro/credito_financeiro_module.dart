import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/cart.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/pagamento_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/product_grid.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'credito_financeiro_screen.dart';

class CreditoFinanceiroModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<HomeWidgetBloc>()),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => CreditoFinanceiroScreen(),
        ),
        Router('/pagamento', child: (_, args) => CreditoPagamentoScreen()),
        Router('/produto', child: (_, args) => CreditProductGridScreen()),
        Router(
          '/produto/:id',
          child: (_, args) => ProductDetailScreen(id: 0, product: args.data),
        ),
        Router(
          '/cart',
          child: (_, args) => CreditCartScreen(),
        ),
      ];
}
