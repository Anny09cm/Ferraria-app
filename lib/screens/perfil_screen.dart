
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ferraria/screens/login_screen.dart';
import 'package:ferraria/screens/direcciones_screen.dart';
import 'package:ferraria/screens/metodos_pago_screen.dart';
import 'package:ferraria/screens/dashboard_vendedor_screen.dart';
import 'package:ferraria/screens/pedidos_vendedor_screen.dart';
import 'package:ferraria/screens/productos_vendedor_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String nombreUsuario = 'Cargando...';
  String correoUsuario = '';
  String rolUsuario = 'cliente'; // Por defecto
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    if (currentUser == null) return;

    try {
      correoUsuario = currentUser!.email ?? '';

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          nombreUsuario = doc.data()?['nombre'] ?? currentUser!.displayName ?? 'Usuario';
          rolUsuario = (doc.data()?['rol'] ?? 'cliente').toString().toLowerCase();
          _isLoadingData = false;
        });
      } else if (mounted) {
        setState(() {
          nombreUsuario = currentUser!.displayName ?? 'Usuario';
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          nombreUsuario = currentUser!.displayName ?? 'Usuario';
          _isLoadingData = false;
        });
      }
    }
  }

  Future<void> _cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool esVendedor = rolUsuario == 'vendedor';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo gris suave
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Perfil',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF73C2FB)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildProfileHeader(esVendedor),

                  const SizedBox(height: 25),


                  if (esVendedor) ...[
                    _buildSectionTitle('Gestión de Ferretería'),
                    _buildGroupContainer([
                      _buildOptionTile(
                        icon: Icons.inventory_2_outlined,
                        title: 'Mis productos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductosVendedorScreen(),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.local_shipping_outlined,
                        title: 'Pedidos por entregar',
                        onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PedidosVendedorScreen(),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.bar_chart_outlined,
                        title: 'Ventas y reportes',
                        onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardVendedorScreen(),
                            ),
                          );
                        },
                      ),
                    ]),
                  ] else ...[
                    _buildSectionTitle('Mis Compras'),
                    _buildGroupContainer([
                      _buildOptionTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Historial de pedidos',
                        onTap: () {

                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.location_on_outlined,
                        title: 'Mis direcciones de envío',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DireccionesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'Mis facturas',
                        onTap: () {},
                      ),
                    ]),
                  ],

                  const SizedBox(height: 20),


                  _buildSectionTitle('Cuenta y Preferencias'),
                  _buildGroupContainer([
                    _buildOptionTile(
                      icon: Icons.person_outline,
                      title: 'Mi Perfil',
                      onTap: () {},
                    ),
                    _buildOptionTile(
                      icon: Icons.notifications_none_outlined,
                      title: 'Notificaciones',
                      onTap: () {},
                    ),
                    _buildOptionTile(
                      icon: Icons.lock_outline,
                      title: 'Seguridad y contraseña',
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 20),

                  _buildSectionTitle('Soporte'),
                  _buildGroupContainer([
                    _buildOptionTile(
                      icon: Icons.help_outline,
                      title: 'Centro de Ayuda',
                      onTap: () {},
                    ),
                    _buildOptionTile(
                      icon: Icons.logout,
                      title: 'Cerrar Sesión',
                      iconColor: Colors.redAccent,
                      textColor: Colors.redAccent,
                      showChevron: false,
                      onTap: _cerrarSesion,
                    ),
                  ]),

                  const SizedBox(height: 90), 
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(bool esVendedor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(77, 0, 0, 0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF73C2FB),
            backgroundImage: currentUser?.photoURL != null
                ? NetworkImage(currentUser!.photoURL!)
                : null,
            child: currentUser?.photoURL == null
                ? Text(
                    nombreUsuario.isNotEmpty ? nombreUsuario[0].toUpperCase() : 'U',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreUsuario,
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  correoUsuario,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                // Etiqueta visual indicando el Rol
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: esVendedor
                        ? const Color(0xFFFFF3CD) // Fondo amarillo suave
                        : const Color(0xFFE3F2FD), // Fondo azul suave
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    esVendedor ? 'Vendedor' : 'Cliente',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: esVendedor
                          ? const Color(0xFF856404)
                          : const Color(0xFF0D47A1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(62, 0, 0, 0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
    bool showChevron = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
          : null,
    );
  }
}