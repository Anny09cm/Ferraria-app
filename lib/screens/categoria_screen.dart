import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/lista_productos_screen.dart';
import 'package:ferraria/widgets/producto_card.dart';

class CategoriaScreen extends StatelessWidget {
  final String categoria;
  final List<Map<String, String>> productos;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        elevation: 4,
        automaticallyImplyLeading: false,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {
  
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          categoria,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  mainAxisExtent: 160,
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final item = productos[index];

                  return GestureDetector(
                    onTap: () {
                      final subcategoria = item["nombre"] ?? '';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListaProductosScreen(
                            tipo: subcategoria, 
                          ),
                        ),
                      );
                    },
                    child: ProductoCard(
                      nombre: item["nombre"] ?? '',
                      imagen: item["imagen"] ?? '',
                      precio: item["precio"] ?? '',
                      puntuacion: double.tryParse(item["puntuacion"] ?? '0.0') ?? 0.0,
                      comentarios: int.tryParse(item["comentarios"] ?? '0') ?? 0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}