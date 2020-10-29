import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/activity_performed_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/complete_create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/confirm_sms_screen.dart';
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
  List<ModularRouter> get routers => [
        ModularRouter('/validate', child: (_, args) => ValidationScreen()),
        ModularRouter(
          '/login',
          child: (_, args) => LoginScreen(),
        ),
        ModularRouter(
          '/createAccount',
          child: (_, args) => CreateAccountScreen(),
        ),
        ModularRouter(
          '/activityPerformed',
          child: (_, args) => ActivityPerformedScreen(),
        ),
        ModularRouter(
          '/completeCreateAccount',
          child: (_, args) => CompleteCreateAccountScreen(),
        ),
        ModularRouter(
          '/passwordReset',
          child: (_, args) => PasswordResetScreen(),
        ),
        ModularRouter(
          '/confirmSms',
          child: (_, args) => ConfirmSmsScreen(phone: args.data),
        ),
      ];
}
