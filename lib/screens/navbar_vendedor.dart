import 'package:ferraria/screens/pedidos_vendedor_screen.dart';
import 'package:ferraria/screens/productos_vendedor_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/dashboard_vendedor_screen.dart';
import 'package:ferraria/screens/login_screen.dart';

class NavBarVendedor extends StatelessWidget {
  const NavBarVendedor({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado del menú
          UserAccountsDrawerHeader(
            accountName: Text(
              'Usuario',
              style: GoogleFonts.nunito(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            accountEmail: Text(
              'usuario@example.com',
              style: GoogleFonts.nunito(
                color: Color(0xFF2971A4),
                fontSize: 14,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white
            ),
          ),

          // Dashboard
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(
              'Dashboard',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardVendedorScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(
              'Pedidos',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PedidosVendedorScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.store),
            title: Text(
              'Productos',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductosVendedorScreen(),
                ),
              );
            },
          ),

          // Clientes
          ListTile(
            leading: const Icon(Icons.group),
            title: Text(
              'Clientes',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Inventario
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(
              'Inventario',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Mensajes
          ListTile(
            leading: const Icon(Icons.message),
            title: Text(
              'Mensajes',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Configuración
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Configuración',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Ayuda y soporte
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(
              'Ayuda y soporte',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // Cerrar sesión
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'Cerrar sesión',
              style: GoogleFonts.nunito(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
               MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          ),
        ],
      ),
    );
  }
}