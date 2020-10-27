import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/activity_performed_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/complete_create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/login_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/password_reset_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/validation_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => i.get<AuthWidgetBloc>()),
        Bind((i) => i.get<AuthBloc>()),
      ];

  @override
  List<Router> get routers => [
        Router(
          '/validate', child: (_, args) => ValidationScreen()
        ),
        Router(
          '/login',
          child: (_, args) => LoginScreen(),
        ),
        Router(
          '/createAccount',
          child: (_, args) => CreateAccountScreen(),
        ),
        Router(
          '/activityPerformed',
          child: (_, args) => ActivityPerformedScreen(),
        ),
        Router(
          '/completeCreateAccount',
          child: (_, args) => CompleteCreateAccountScreen(),
        ),
        Router(
          '/passwordReset',
          child: (_, args) => PasswordResetScreen(),
        ),
      ];
}
