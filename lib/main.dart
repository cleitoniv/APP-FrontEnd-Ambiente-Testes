import 'package:central_oftalmica_app_cliente/modules/app/app_module.dart';
import 'package:central_oftalmica_app_cliente/modules/app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  runApp(
    ModularApp(module: AppModule(), child: AppWidget()),
  );
}
