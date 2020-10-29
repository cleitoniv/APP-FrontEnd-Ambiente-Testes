import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/user_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/app_users_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/delivery_address_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/form_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/personal_info_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/profile_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/security_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => i.get<ProfileWidgetBloc>(),
        ),
        Bind(
          (i) => i.get<UserBloc>(),
        ),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, args) => ProfileScreen(),
        ),
        ModularRouter(
          '/personalInfo',
          child: (_, args) => PersonalInfoScreen(),
        ),
        ModularRouter(
          '/deliveryAddress',
          child: (_, args) => DeliveryAddressScreen(),
        ),
        ModularRouter(
          '/security',
          child: (_, args) => SecurityScreen(),
        ),
        ModularRouter(
          '/appUsers',
          child: (_, args) => AppUsersScreen(),
        ),
        ModularRouter(
          '/appUsers/:type',
          child: (_, args) => FormScreen(
            formType: args.params['type'],
            usuario: args.data,
          ),
        ),
      ];
}
