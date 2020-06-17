import 'package:central_oftalmica_app_cliente/blocs/profile_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/app_users_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/profile/delivery_address_screen.dart';
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
      ];

  @override
  List<Router> get routers => [
        Router(
          '/',
          child: (_, args) => ProfileScreen(),
        ),
        Router(
          '/personalInfo',
          child: (_, args) => PersonalInfoScreen(),
        ),
        Router(
          '/deliveryAddress',
          child: (_, args) => DeliveryAddressScreen(),
        ),
        Router(
          '/security',
          child: (_, args) => SecurityScreen(),
        ),
        Router(
          '/appUsers',
          child: (_, args) => AppUsersScreen(),
        ),
      ];
}
