import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/auth/login',
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff56B952),
        accentColor: Color(0xff36AFC6),
        scaffoldBackgroundColor: Colors.white,
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          brightness: Brightness.light,
          textTheme: TextTheme(
            headline6: GoogleFonts.poppins().copyWith(
              fontSize: 18,
              color: Color(0xffA5A5A5),
              fontWeight: FontWeight.w600,
            ),
            headline5: GoogleFonts.poppins().copyWith(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(
            color: Color(0xffA5A5A5),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xff36AFC6),
          height: 50,
          minWidth: double.infinity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        textTheme: TextTheme(
          headline6: GoogleFonts.poppins().copyWith(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          headline5: GoogleFonts.poppins().copyWith(
            fontSize: 24,
            color: Color(0xff36AFC6),
            fontWeight: FontWeight.w600,
          ),
          headline4: GoogleFonts.poppins().copyWith(
            fontSize: 20,
            color: Color(0xff36AFC6),
            fontWeight: FontWeight.bold,
          ),
          subtitle2: GoogleFonts.poppins().copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
          subtitle1: GoogleFonts.poppins().copyWith(
            fontSize: 16,
            color: Color(0xff444443),
          ),
          button: GoogleFonts.poppins().copyWith(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
