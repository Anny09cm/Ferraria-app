import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:ferraria/screens/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // =========================================================
  // CONTROLADORES
  // =========================================================

  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // =========================================================
  // VARIABLES
  // =========================================================

  String _rolSeleccionado = 'cliente';

  bool _isLoading = false;

  // =========================================================
  // LIBERAR CONTROLADORES
  // =========================================================

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // =========================================================
  // REGISTRO CON CORREO Y CONTRASEÑA
  // =========================================================

  Future<void> _registrarConEmail() async {
    final nombre = _nombreController.text.trim();
    final telefono = _telefonoController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword =
        _confirmPasswordController.text.trim();

    // -------------------------
    // VALIDACIONES
    // -------------------------

    if (nombre.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _mostrarSnackBar(
        'Por favor, completa los campos obligatorios',
      );
      return;
    }

    if (password != confirmPassword) {
      _mostrarSnackBar(
        'Las contraseñas no coinciden',
      );
      return;
    }

    if (password.length < 6) {
      _mostrarSnackBar(
        'La contraseña debe tener al menos 6 caracteres',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear usuario en Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Actualizar nombre del usuario
        await user.updateDisplayName(nombre);

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'nombre': nombre,
          'telefono': telefono,
          'email': email,
          'rol': _rolSeleccionado,
          'fechaRegistro':
              FieldValue.serverTimestamp(),
        });

        if (!mounted) return;

        _navegarAMainScreen();
      }
    } on FirebaseAuthException catch (e) {
      String mensaje = 'Ocurrió un error';

      if (e.code == 'email-already-in-use') {
        mensaje = 'Este correo ya está registrado';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es demasiado débil';
      } else if (e.code == 'network-request-failed') {
        mensaje = 'Revisa tu conexión a Internet';
      }

      _mostrarSnackBar(mensaje);
    } catch (e) {
      _mostrarSnackBar(
        'Error al registrarse: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // =========================================================
  // REGISTRO / INICIO CON GOOGLE
  // =========================================================

  Future<void> _registrarConGoogle() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Google Sign-In 7.x utiliza una instancia única
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    // Inicializar Google Sign-In
    await googleSignIn.initialize();

    // Abrir selección de cuenta de Google
    final GoogleSignInAccount googleUser =
        await googleSignIn.authenticate();

    // Obtener autenticación
    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    // En google_sign_in 7.x se utiliza el ID Token.
    // accessToken ya no forma parte de GoogleSignInAuthentication.
    final AuthCredential credential =
        GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Iniciar sesión en Firebase
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    final User? user = userCredential.user;

    if (user != null) {
      final DocumentReference userDoc =
          FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid);

      final DocumentSnapshot snapshot =
          await userDoc.get();

      // Si es un usuario nuevo, guardar sus datos
      if (!snapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'nombre':
              user.displayName ?? 'Usuario Google',
          'telefono':
              user.phoneNumber ?? '',
          'email':
              user.email ?? '',
          'rol': _rolSeleccionado,
          'fechaRegistro':
              FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      _navegarAMainScreen();
    }
  } on GoogleSignInException catch (e) {
    _mostrarSnackBar(
      'No se pudo iniciar sesión con Google: ${e.description ?? e.code}',
    );
  } on FirebaseAuthException catch (e) {
    _mostrarSnackBar(
      'Error de Firebase: ${e.message ?? e.code}',
    );
  } catch (e) {
    _mostrarSnackBar(
      'Error al iniciar sesión con Google: $e',
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  // =========================================================
  // NAVEGAR A MAIN SCREEN
  // =========================================================

  void _navegarAMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
      (route) => false,
    );
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void _mostrarSnackBar(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          texto,
          style: GoogleFonts.nunito(),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          // =================================================
          // LOGO
          // =================================================

          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width:
                  MediaQuery.of(context).size.height *
                      0.25,
              height:
                  MediaQuery.of(context).size.height *
                      0.25,
            ),
          ),

          // =================================================
          // CONTENEDOR PRINCIPAL
          // =================================================

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
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),

                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // =====================================
                      // TÍTULO
                      // =====================================

                      SizedBox(
                        width: double.infinity,

                        child: Text(
                          'Regístrate',
                          textAlign: TextAlign.center,

                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // SELECTOR DE ROL
                      // =====================================

                      Text(
                        '¿Cómo deseas usar la app?',

                        style:
                            GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [

                          Expanded(
                            child: _buildRolOption(
                              label: 'Cliente',
                              value: 'cliente',
                              icon:
                                  Icons.person_outline,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: _buildRolOption(
                              label: 'Vendedor',
                              value: 'vendedor',
                              icon:
                                  Icons.storefront_outlined,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // NOMBRE
                      // =====================================

                      Text(
                        'Nombre completo',
                        style:
                            _estiloTextoBlanco(),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            _nombreController,

                        decoration:
                            _buildInputDecoration(
                          'Nombre',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // TELÉFONO
                      // =====================================

                      Text(
                        'Teléfono',
                        style:
                            _estiloTextoBlanco(),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            _telefonoController,

                        keyboardType:
                            TextInputType.phone,

                        decoration:
                            _buildInputDecoration(
                          'Teléfono',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // CORREO
                      // =====================================

                      Text(
                        'Correo',
                        style:
                            _estiloTextoBlanco(),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            _emailController,

                        keyboardType:
                            TextInputType.emailAddress,

                        decoration:
                            _buildInputDecoration(
                          'Correo',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // CONTRASEÑA
                      // =====================================

                      Text(
                        'Crea una contraseña',
                        style:
                            _estiloTextoBlanco(),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            _passwordController,

                        obscureText: true,

                        decoration:
                            _buildInputDecoration(
                          'Contraseña nueva',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // CONFIRMAR CONTRASEÑA
                      // =====================================

                      Text(
                        'Confirma la contraseña',
                        style:
                            _estiloTextoBlanco(),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            _confirmPasswordController,

                        obscureText: true,

                        decoration:
                            _buildInputDecoration(
                          'Confirmar contraseña',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // BOTÓN CONTINUAR
                      // =====================================

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                              0xFF2971A4,
                            ),

                            padding:
                                const EdgeInsets
                                    .symmetric(
                              vertical: 15,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(20),
                            ),
                          ),

                          onPressed:
                              _isLoading
                                  ? null
                                  : _registrarConEmail,

                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,

                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Continuar',

                                  style:
                                      GoogleFonts
                                          .nunito(
                                    color:
                                        Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // DIVISOR
                      // =====================================

                      Row(
                        children: [

                          const Expanded(
                            child: Divider(
                              color: Colors.white54,
                            ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 10,
                            ),

                            child: Text(
                              'O regístrate con',

                              style:
                                  GoogleFonts.nunito(
                                fontSize: 14,
                                color:
                                    const Color(
                                  0xFF2971A4,
                                ),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const Expanded(
                            child: Divider(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // =====================================
                      // GOOGLE / APPLE
                      // =====================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,

                        children: [

                          // GOOGLE
                          ElevatedButton.icon(
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors.white,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(15),
                              ),
                            ),

                            onPressed:
                                _isLoading
                                    ? null
                                    : _registrarConGoogle,

                            icon: const FaIcon(
                              FontAwesomeIcons
                                  .google,

                              color:
                                  Color(0xFF2971A4),
                            ),

                            label: Text(
                              'Google',

                              style:
                                  GoogleFonts
                                      .nunito(
                                fontSize: 14,
                                color:
                                    const Color(
                                  0xFF2971A4,
                                ),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          // APPLE
                          ElevatedButton.icon(
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors.white,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(15),
                              ),
                            ),

                            onPressed: () {
                              _mostrarSnackBar(
                                'Apple Sign In se habilitará próximamente',
                              );
                            },

                            icon: const FaIcon(
                              FontAwesomeIcons.apple,
                              color:
                                  Color(0xFF2971A4),
                            ),

                            label: Text(
                              'Apple',

                              style:
                                  GoogleFonts
                                      .nunito(
                                fontSize: 14,
                                color:
                                    const Color(
                                  0xFF2971A4,
                                ),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
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

  // =========================================================
  // ESTILO DE TEXTOS
  // =========================================================

  TextStyle _estiloTextoBlanco() {
    return GoogleFonts.nunito(
      color: Colors.white,
      fontSize: 16,
    );
  }

  // =========================================================
  // DECORACIÓN DE INPUTS
  // =========================================================

  InputDecoration _buildInputDecoration(
    String hint,
  ) {
    return InputDecoration(
      filled: true,

      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(20),

        borderSide: BorderSide.none,
      ),

      hintText: hint,

      hintStyle:
          GoogleFonts.nunito(
        color: Colors.grey[600],
        fontSize: 14,
      ),
    );
  }

  // =========================================================
  // OPCIÓN CLIENTE / VENDEDOR
  // =========================================================

  Widget _buildRolOption({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final bool isSelected =
        _rolSeleccionado == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _rolSeleccionado = value;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),

        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2971A4)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(15),

          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.15),
                    blurRadius: 6,
                    offset:
                        const Offset(0, 3),
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,

              color: isSelected
                  ? Colors.white
                  : const Color(0xFF2971A4),

              size: 20,
            ),

            const SizedBox(width: 8),

            Text(
              label,

              style:
                  GoogleFonts.nunito(
                color: isSelected
                    ? Colors.white
                    : const Color(
                        0xFF2971A4,
                      ),

                fontWeight:
                    FontWeight.bold,

                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}