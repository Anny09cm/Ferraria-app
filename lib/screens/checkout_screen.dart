import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ferraria/services/cart_favorites_service.dart';
import 'package:ferraria/screens/direcciones_screen.dart';
import 'package:ferraria/screens/metodos_pago_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalPagar;

  const CheckoutScreen({
    super.key,
    required this.totalPagar,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _direccionSeleccionadaId;
  String? _metodoPagoSeleccionadoId;

  Map<String, dynamic>? _direccionData;
  Map<String, dynamic>? _metodoPagoData;

  bool _cargando = false;

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;
  Future<void> _confirmarPedido() async {
    if (_direccionSeleccionadaId == null) {
      _mostrarMensaje(
        'Por favor selecciona una dirección de envío',
        Color(0xFF2971A4), 
      );
    return;
    }

    if (_metodoPagoSeleccionadoId == null) {
      _mostrarMensaje(
        'Por favor selecciona un método de pago',
        Color(0xFF2971A4),
      );
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      if (_uid != null) {
        final carritoSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(_uid)
            .collection('carrito')
            .get();

        final productos = carritoSnapshot.docs.map((doc) => doc.data()).toList();

        await FirebaseFirestore.instance.collection('pedidos').add({
          'usuarioId': _uid,
          'total': widget.totalPagar,
          'direccion': _direccionData,
          'metodoPago': _metodoPagoData,
          'productos': productos,
          'fecha': FieldValue.serverTimestamp(),
          'estado': 'Pendiente',
        });
      }

      await CartFavoritesService.vaciarCarrito();

      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: const EdgeInsets.fromLTRB(25, 30, 25, 20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(109, 115, 194, 251),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF73C2FB),
                    size: 55,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  '¡Pedido confirmado!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2971A4),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Gracias por tu compra. En breve procesaremos el envío de tus productos.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF73C2FB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      );
                    },
                    child: Text(
                      'Volver al inicio',
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarMensaje(
        'Error al procesar pedido',
        Color(0xFF2971A4),
      );
    }
  }

  void _mostrarMensaje(
    String mensaje,
    Color color,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            mensaje,
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: Text(
          'Confirmar compra',
          style: GoogleFonts.nunito(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),

      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF73C2FB),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTituloSeccion(
                    icon: Icons.location_on_outlined,
                    titulo: 'Dirección de envío',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DireccionesScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(_uid)
                        .collection('direcciones')
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Color(0xFF73C2FB),
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return _buildEmptySelector(
                          'No tienes direcciones guardadas',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DireccionesScreen(),
                              ),
                            );
                          },
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          final seleccionado = _direccionSeleccionadaId == doc.id;

                          return _buildSelectorCard(
                            seleccionado: seleccionado,
                            icon: Icons.location_on_outlined,
                            titulo: data['alias'] ?? 'Dirección',
                            subtitulo:
                            '${data['calle']}, CP ${data['cp']}',
                            onTap: () {
                              setState(() {
                                _direccionSeleccionadaId = doc.id;
                                _direccionData = data;
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  _buildTituloSeccion(
                    icon: Icons.credit_card_outlined,
                    titulo: 'Método de pago',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MetodosPagoScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(_uid)
                        .collection('metodos_pago')
                        .snapshots(),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              color: Color(0xFF73C2FB),
                            ),
                          ),
                        );
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return _buildEmptySelector(
                          'No tienes tarjetas guardadas',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MetodosPagoScreen(),
                              ),
                            );
                          },
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final seleccionado = _metodoPagoSeleccionadoId == doc.id;

                          return _buildSelectorCard(
                            seleccionado: seleccionado,
                            icon: Icons.credit_card_outlined,
                            titulo:
                                '•••• ${data['ultimos4']}',
                            subtitulo:
                                '${data['tipo']} - ${data['titular']}',
                            onTap: () {
                              setState(() {
                                _metodoPagoSeleccionadoId = doc.id;
                                _metodoPagoData = data;
                              });
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(97, 0, 0, 0),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,

                              decoration: BoxDecoration(
                                color: const Color.fromARGB(121, 115, 194, 251),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),

                              child: const Icon(
                                Icons.receipt_long_outlined,
                                color: Color(0xFF2971A4),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              'Resumen del pedido',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        const Divider(),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total a pagar',
                              style: GoogleFonts.nunito(
                                fontSize: 17,
                                color: Colors.grey[700],
                              ),
                            ),

                            Text(
                              'MXN ${widget.totalPagar.toStringAsFixed(2)}',
                              style: GoogleFonts.nunito(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color:
                                    const Color(0xFF2971A4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),

                    child: SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2971A4),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor:const Color(0xFF2971A4),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                              BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: _confirmarPedido,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 20,
                            ),

                            const SizedBox(width: 10),

                            Text(
                              'Pagar y confirmar pedido',
                              style: GoogleFonts.nunito(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'Pago seguro',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTituloSeccion({
    required IconData icon,
    required String titulo,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF2971A4),
          size: 23,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            titulo,
            style: GoogleFonts.nunito(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        TextButton(
          onPressed: onPressed,
          child: Text(
            'Gestionar',
            style: GoogleFonts.nunito(
              color: const Color(0xFF2971A4),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorCard({
    required bool seleccionado,
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        width: double.infinity,

        margin: const EdgeInsets.only(bottom: 10),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFF73C2FB)
                : Colors.transparent,
            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(106, 0, 0, 0),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: seleccionado
                    ? const Color.fromARGB(84, 115, 194, 251)
                    : Colors.grey[100],

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: seleccionado
                    ? const Color(0xFF2971A4)
                    : Colors.grey[600],
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitulo,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 200),

              child: seleccionado
                  ? const Icon(
                      Icons.check_circle_rounded,
                      key: ValueKey('selected'),
                      color: Color(0xFF73C2FB),
                      size: 27,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      key: const ValueKey('unselected'),
                      color: Colors.grey[400],
                      size: 25,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySelector(
    String texto,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              texto,
              style: GoogleFonts.nunito(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(width: 10),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF73C2FB),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            onPressed: onTap,

            child: Text(
              'Agregar',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}