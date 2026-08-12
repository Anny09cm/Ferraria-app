import 'package:flutter/material.dart';
import 'package:ferraria/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AppFerraria());
}

class AppFerraria extends StatelessWidget {
  const AppFerraria({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FERRARIA',
      theme: ThemeData(
        textTheme: GoogleFonts.orientaTextTheme(),
      ),
      home: const LoginScreen(), 
    );
  }
}

