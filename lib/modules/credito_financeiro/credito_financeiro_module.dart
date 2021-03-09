import 'package:central_oftalmica_app_cliente/blocs/home_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/cart.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/pagamento_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/credito_financeiro/finish_payment_screen.dart';
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
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => CreditoFinanceiroScreen(),
        ),
        ModularRouter('/pagamento',
            child: (_, args) => CreditoPagamentoScreen()),
        ModularRouter('/produto',
            child: (_, args) => CreditProductGridScreen()),
        ModularRouter(
          '/produto/:id',
          child: (_, args) => ProductDetailScreen(id: 0, product: args.data),
        ),
        ModularRouter(
          '/cart',
          child: (_, args) => CreditCartScreen(),
        ),
        ModularRouter(
          '/finishPayment',
          child: (_, args) => FinishPayment(),
        )
      ];
}
