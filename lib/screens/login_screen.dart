import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ferraria/screens/password_screen.dart';
import 'package:ferraria/screens/register_screen.dart';
import 'package:ferraria/screens/main_screen.dart';

class LoginScreen extends StatelessWidget { 
  const LoginScreen({super.key}); 

  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Column( 
        children: [ 
          Center( 
            child: Image.asset( 
              'assets/images/logo.png', 
              width: MediaQuery.of(context).size.height * 0.30, 
              height: MediaQuery.of(context).size.height * 0.30, 
            ), 
          ), 

          Expanded( 
            child: Container(  
              decoration: const BoxDecoration(
                color: Color(0xFF73C2FB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding( 
                padding: const EdgeInsets.symmetric( 
                  horizontal: 25, 
                  vertical: 15, 
                ), 
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column( 
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [ 
                      SizedBox(
                        width: double.infinity,
                        child: Text( 
                          'Inicia Sesión', 
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito( 
                            textStyle: const TextStyle( 
                              color: Colors.white, 
                              fontSize: 26, 
                              fontWeight: FontWeight.bold, 
                            ), 
                          ), 
                        ), 
                      ),

                      const SizedBox(height: 15), 

                      Text( 
                        'Correo electrónico', 
                        style: GoogleFonts.nunito( 
                          textStyle: const TextStyle( 
                            color: Colors.white, 
                            fontSize: 18, 
                          ), 
                        ), 
                      ), 

                      const SizedBox(height: 10), 

                      TextField( 
                        decoration: InputDecoration( 
                          filled: true, 
                          fillColor: Colors.white, 
                          border: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(20), 
                            borderSide: BorderSide.none, 
                          ), 
                          hintText: 'Correo',
                          hintStyle: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),  
                        ), 
                      ), 

                      const SizedBox(height: 10), 

                      Text( 
                        'Ingresa tu contraseña', 
                        style: GoogleFonts.nunito( 
                          textStyle: const TextStyle( 
                            color: Colors.white, 
                            fontSize: 18, 
                          ), 
                        ), 
                      ), 

                      const SizedBox(height: 15), 

                      TextField( 
                        obscureText: true,
                        decoration: InputDecoration( 
                          filled: true, 
                          fillColor: Colors.white, 
                          border: OutlineInputBorder( 
                            borderRadius: BorderRadius.circular(20), 
                            borderSide: BorderSide.none, 
                          ), 
                          hintText: 'Contraseña', 
                          hintStyle: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ), 
                      ), 

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton( 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: const Color(0xFF2971A4),
                            padding: const EdgeInsets.symmetric(  
                              vertical: 15, 
                            ),
                          ), 
                          onPressed: () {
                            Navigator.pushReplacement( 
                              context, 
                              MaterialPageRoute( 
                                builder: (context) => const MainScreen(), 
                              ), 
                            ); 
                          }, 
                          child: Text(
                            'Continuar', 
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle( 
                                color: Colors.white, 
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align (
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const PasswordScreen(), 
                              ),
                            );
                          },
                          child: Text(
                            "¿Olvidaste tu contraseña?", 
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ), 
                        ),
                      ),

                      const SizedBox(height: 15),
                      
                      Row (
                        children: [

                          const Expanded(child: Divider()),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("O continua con", 
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2971A4),
                                ),
                              ),
                            ),
                          ),

                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: (){},
                            icon: FaIcon(FontAwesomeIcons.google,
                            color: Color(0xFF2971A4),
                            ),
                            label: Text(
                              "Google",
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color (0xFF2971A4),
                                ),
                              ),
                            ),
                          ),

                         ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: (){},
                            icon: FaIcon(FontAwesomeIcons.apple,
                            color: Color(0xFF2971A4),
                            ),
                             label: Text(
                               "Apple",
                               style: GoogleFonts.nunito(
                                 textStyle: const TextStyle(
                                   fontSize: 16,
                                   color: Color (0xFF2971A4),
                                 ),
                               ),
                             ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes una cuenta?", 
                            style: GoogleFonts.nunito(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2971A4),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              " Crear cuenta",
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF2971A4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ], 
                  ),
                ), 
              ), 
            ), 
          ),
        ], 
      ), 
    ); 
  } 
}