import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:ferraria/screens/password_screen.dart';
import 'package:ferraria/screens/register_screen.dart';
import 'package:ferraria/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // =========================================================
  // CONTROLADORES Y VARIABLES
  // =========================================================
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // INICIAR SESIÓN CON CORREO Y CONTRASEÑA
  // =========================================================
  Future<void> _iniciarSesionEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _mostrarSnackBar('Por favor ingresa tu correo y contraseña');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      _navegarAMainScreen();
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Error al iniciar sesión';
      if (e.code == 'user-not-found') {
        mensaje = 'No existe una cuenta con este correo';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        mensaje = 'Correo o contraseña incorrectos';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido';
      } else if (e.code == 'network-request-failed') {
        mensaje = 'Revisa tu conexión a Internet';
      }
      _mostrarSnackBar(mensaje);
    } catch (e) {
      _mostrarSnackBar('Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================
  // INICIAR SESIÓN CON GOOGLE (Versión 7.x)
  // =========================================================
  Future<void> _iniciarSesionGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      _navegarAMainScreen();
    } on GoogleSignInException catch (e) {
      _mostrarSnackBar(
        'No se pudo iniciar sesión con Google: ${e.description ?? e.code}',
      );
    } on FirebaseAuthException catch (e) {
      _mostrarSnackBar('Error de Firebase: ${e.message ?? e.code}');
    } catch (e) {
      _mostrarSnackBar('Error al conectar con Google: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // =========================================================
  // NAVEGACIÓN Y SNACKBAR
  // =========================================================
  void _navegarAMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  void _mostrarSnackBar(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto, style: GoogleFonts.nunito()),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // =========================================================
  // VISTA PRINCIPAL
  // =========================================================
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
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
                        controller: _passwordController,
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
                          onPressed: _isLoading ? null : _iniciarSesionEmail, 
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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

                      Align(
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
                      
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "O continua con", 
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
                            onPressed: _isLoading ? null : _iniciarSesionGoogle,
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Color(0xFF2971A4),
                            ),
                            label: Text(
                              "Google",
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2971A4),
                                ),
                              ),
                            ),
                          ),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              _mostrarSnackBar('El inicio con Apple estará disponible en producción');
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.apple,
                              color: Color(0xFF2971A4),
                            ),
                            label: Text(
                              "Apple",
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2971A4),
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
                            onTap: () {
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