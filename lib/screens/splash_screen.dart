import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ferraria/screens/login_screen.dart';
import 'package:ferraria/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color azulClaro = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);

  @override
  void initState() {
    super.initState();
    _iniciarApp();
  }

  Future<void> _iniciarApp() async {

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 230,
                height: 230,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: azulClaro,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'FERRARIA',
                style: TextStyle(
                  color: azulOscuro,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}