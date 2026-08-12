import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ferraria/screens/main_screen.dart';

class RegisterScreen extends StatelessWidget {
   const RegisterScreen({super.key});


  @override

   Widget build(BuildContext context) {
     return Scaffold(
       body: Column(
          children: [
            Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.height * 0.25,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
              ),
  
              
              Expanded(
                child: Container(  
                  decoration: BoxDecoration(
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
                        'Registrate', 
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito( 
                          textStyle: const TextStyle( 
                            color: Colors.white, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                          ), 
                        ), 
                      ), 
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Nombre completo",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )
                      ) ,
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
                        hintText: 'Nombre',
                        hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                          color: Colors.grey[600],      
                          fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Teléfono",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )
                      ) ,
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
                        hintText: 'Teléfono',  
                        hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      "Correo", 
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Crea una contraseña", 
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration( 
                        filled: true, 
                        fillColor: Colors.white, 
                        border: OutlineInputBorder( 
                          borderRadius: BorderRadius.circular(20), 
                          borderSide: BorderSide.none, 
                        ), 
                        hintText: 'Contraseña nueva', 
                        hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Confirma la contraseña", 
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration( 
                        filled: true, 
                        fillColor: Colors.white, 
                        border: OutlineInputBorder( 
                          borderRadius: BorderRadius.circular(20), 
                          borderSide: BorderSide.none, 
                        ), 
                        hintText: 'Contraseña nueva', 
                        hintStyle: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton( 
                        style: ElevatedButton.styleFrom( 
                          backgroundColor: Color(0xFF2971A4),
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
                            fontSize: 16 
                          ),
                        ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row (
                      children: [

                        Expanded(child: Divider()),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "O registrate con", 
                            style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2971A4),
                          ),
                          ),
                          ),
                        ),
                          Expanded(child: Divider()),
                      ],
                      ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
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
                              textStyle: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2971A4),
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
                                   fontSize: 14,
                                   color: Color (0xFF2971A4),
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