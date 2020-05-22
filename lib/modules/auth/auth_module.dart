import 'package:central_oftalmica_app_cliente/modules/auth/create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/login_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/password_reset_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<Router> get routers => [
        Router(
          '/login',
          child: (_, args) => LoginScreen(),
        ),
        Router(
          '/createAccount',
          child: (_, args) => CreateAccountScreen(),
        ),
        Router(
          '/passwordReset',
          child: (_, args) => PasswordResetScreen(),
        ),
      ];
}
