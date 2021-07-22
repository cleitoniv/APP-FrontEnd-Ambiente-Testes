import 'package:central_oftalmica_app_cliente/blocs/auth_bloc.dart';
import 'package:central_oftalmica_app_cliente/blocs/auth_widget_bloc.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/activity_performed_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/complete_create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/confirm_sms_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/create_account_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/login_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/password_reset_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/terms_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/validation_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/auth/delivery_address_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => i.get<AuthWidgetBloc>()),
    Bind((i) => i.get<AuthBloc>()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/validate', child: (_, args) => ValidationScreen()),
    ChildRoute(
      '/login',
      child: (_, args) => LoginScreen(),
    ),
    ChildRoute(
      '/createAccount',
      child: (_, args) => CreateAccountScreen(),
    ),
    ChildRoute(
      '/activityPerformed',
      child: (_, args) => ActivityPerformedScreen(),
    ),
    ChildRoute(
      '/completeCreateAccount',
      child: (_, args) => CompleteCreateAccountScreen(),
    ),
    ChildRoute(
      '/deliveryAddressRegister',
      child: (_, args) => DeliveryAddressRegisterScreen(),
    ),
    ChildRoute(
      '/passwordReset',
      child: (_, args) => PasswordResetScreen(),
    ),
    ChildRoute(
      '/confirmSms',
      child: (_, args) => ConfirmSmsScreen(phone: args.data),
    ),
    ChildRoute(
      '/terms',
      child: (_, args) => TermsResponsability(),
    ),
  ];
}
