import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/intro',
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFBFBFB),
        textTheme: TextTheme(
          headline6: GoogleFonts.poppins().copyWith(
            fontSize: 24,
            color: Colors.white,
          ),
          subtitle2: GoogleFonts.poppins().copyWith(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
