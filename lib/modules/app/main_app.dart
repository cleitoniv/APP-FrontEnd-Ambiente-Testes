import 'package:central_oftalmica_app_cliente/modules/app/intro_screen.dart';
import 'package:central_oftalmica_app_cliente/modules/home/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return StreamBuilder<User>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // if (snapshot.hasData && (!snapshot.data.isAnonymous)) {
              //   return TabsScreen(
              //     index: 0,
              //   );
              // }

              // return IntroScreen();
              if (snapshot.hasData) {
                if (snapshot.data.providerData.length == 1) {
                  return TabsScreen(
                    index: 0,
                  );
                }
                return IntroScreen();
              } else {
                return IntroScreen();
              }
            },
          );
        });
  }
}
