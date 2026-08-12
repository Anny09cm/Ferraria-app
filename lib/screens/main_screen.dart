import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:ferraria/screens/catalogo_screen.dart';
import 'package:ferraria/screens/search_screen.dart';
import 'package:ferraria/screens/home_screen.dart';
import 'package:ferraria/screens/carrito_screen.dart';
import 'package:ferraria/screens/perfil_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

  class _MainScreenState extends State<MainScreen>{
    
    int index = 2;

      final screens = [
      const CatalogoScreen(),
      const SearchScreen(),
      const HomeScreen(),
      const CarritoScreen(),
      const PerfilScreen(),
    ];

    @override
    Widget build(BuildContext context) {

    final items = <Widget>[
      Icon(Icons.grid_view, size: 30),
      Icon(Icons.search, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.shopping_cart, size: 30),
      Icon(Icons.person, size: 30),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[index],
        bottomNavigationBar: 
      Theme (
        data:Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
        color: Color(0xFF73C2FB),
        buttonBackgroundColor: Color(0xFF73C2FB),
        backgroundColor:  Colors.transparent,
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        items: items,
        index: index,
        onTap: (value){
          setState(() {
            index = value;
          });
        },
        ),
      ),
    );
  }
}