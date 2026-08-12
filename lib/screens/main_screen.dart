import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:ferraria/screens/catalogo_screen.dart';
import 'package:ferraria/screens/search_screen.dart';
import 'package:ferraria/screens/home_screen.dart';
import 'package:ferraria/screens/carrito_screen.dart';
import 'package:ferraria/screens/perfil_screen.dart';

import 'package:ferraria/screens/dashboard_vendedor_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 2;

  String _rol = 'cliente';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _obtenerRolUsuario();
  }

  Future<void> _obtenerRolUsuario() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('usuarios')
                .doc(currentUser.uid)
                .get();

        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data() as Map<String, dynamic>;

          if (mounted) {
            setState(() {
              _rol = data['rol'] ?? 'cliente';
              _isLoading = false;
            });
          }

          return;
        }
      } catch (e) {
        debugPrint('Error al obtener el rol: $e');
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF73C2FB),
          ),
        ),
      );
    }

    final bool esVendedor = _rol == 'vendedor';

    // ============================
    // PANTALLAS DEL VENDEDOR
    // ============================

    final List<Widget> screens = esVendedor
        ? [
            const DashboardVendedorScreen(),
            const SearchScreen(),
            const DashboardVendedorScreen(),
            const PerfilScreen(),
          ]

        // ============================
        // PANTALLAS DEL CLIENTE
        // ============================

        : [
            const CatalogoScreen(),
            const SearchScreen(),
            const HomeScreen(),
            const CarritoScreen(),
            const PerfilScreen(),
          ];

    // ============================
    // ICONOS
    // ============================

    final List<Widget> items = esVendedor
        ? const [
            Icon(
              Icons.dashboard_outlined,
              size: 30,
            ),
            Icon(
              Icons.search,
              size: 30,
            ),
            Icon(
              Icons.storefront,
              size: 30,
            ),
            Icon(
              Icons.person,
              size: 30,
            ),
          ]
        : const [
            Icon(
              Icons.grid_view,
              size: 30,
            ),
            Icon(
              Icons.search,
              size: 30,
            ),
            Icon(
              Icons.home,
              size: 30,
            ),
            Icon(
              Icons.shopping_cart,
              size: 30,
            ),
            Icon(
              Icons.person,
              size: 30,
            ),
          ];

    // Evita errores si cambia la cantidad de pantallas
    final int safeIndex =
        index >= screens.length ? 0 : index;

    return Scaffold(
      extendBody: true,

      body: screens[safeIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: CurvedNavigationBar(
          color: const Color(0xFF73C2FB),

          buttonBackgroundColor:
              const Color(0xFF73C2FB),

          backgroundColor: Colors.transparent,

          height: 60,

          animationCurve: Curves.easeInOut,

          animationDuration:
              const Duration(milliseconds: 300),

          items: items,

          index: safeIndex,

          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }
}