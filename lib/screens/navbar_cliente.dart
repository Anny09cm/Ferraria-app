import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/carrito_screen.dart';
import 'package:ferraria/screens/favoritos_screen.dart';

class NavBarCliente extends StatelessWidget {
  const NavBarCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
        UserAccountsDrawerHeader(
          accountName:  Text(
            'Usuario',
            style: GoogleFonts.nunito (
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          accountEmail:  Text(
            'usuario@example.com',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Color (0xFF2971A4),
              fontSize: 14,
            ),
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person, 
              color: Colors.white,
              size: 50, 
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text(
            'Dashboard',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
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
                builder: (context) => const CarritoScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.inventory_2),
          title: Text(
            'Mis pedidos',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite_border),
          title: Text(
            'Favoritos',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritosScreen(),
              ),
              );
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text(
            'Comprar de nuevo',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text(
            'Direcciones',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text(
            'Metodos de pago',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            'Configuración',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text(
            'Ayuda y soporte',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(
            'Cerrar sesión',
            style: GoogleFonts.nunito (
              textStyle: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ],
      ),
    );
  }
}