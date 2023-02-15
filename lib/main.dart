import 'package:central_oftalmica_app_cliente/modules/app/app_module.dart';
import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ModularApp(module: AppModule(), child: AppWidget()),
    );
  });
}
