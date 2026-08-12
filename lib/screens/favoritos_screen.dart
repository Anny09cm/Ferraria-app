import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/widgets/favoritos.dart';
import 'package:ferraria/widgets/producto_card.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritos = FavoritosService.favoritos;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
        ),
        title: Text(
          'Favoritos',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: favoritos.isEmpty
          ? Center(
              child: Text(
                'No tienes productos favoritos.',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 200,
                ),
                itemCount: favoritos.length,
                itemBuilder: (context, index) {
                  final producto = favoritos[index];

                  return Stack(
                    children: [
                      ProductoCard(
                        imagen: producto["imagen"]!,
                        nombre: producto["nombre"]!,
                        precio: producto["precio"]!,
                        puntuacion: 4.5,
                        comentarios: 15,
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${producto["nombre"]} agregado al carrito 🛒',
                                style: GoogleFonts.nunito(),
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF2971A4),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                FavoritosService.eliminar(
                                  producto["nombre"]!,
                                );
                              });
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFF73C2FB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}