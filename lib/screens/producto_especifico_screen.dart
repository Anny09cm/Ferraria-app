import 'package:ferraria/screens/favoritos_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widgets modulares
import 'package:ferraria/widgets/informacion_producto_card.dart';
import 'package:ferraria/widgets/descripcion_card.dart';
import 'package:ferraria/widgets/especificaciones_card.dart';

class ProductoEspecificoScreen extends StatelessWidget {
  final String nombre;
  final String precio;
  final String imagen;
  final List<String>? imagenes;
  final String? sku;
  final double? puntuacion;
  final int? comentarios;
  final int? disponibles;

  const ProductoEspecificoScreen({
    super.key,
    required this.nombre,
    required this.precio,
    required this.imagen,
    this.imagenes,
    this.sku,
    this.puntuacion,
    this.comentarios,
    this.disponibles,
  });

  @override
  Widget build(BuildContext context) {
    final listaImagenes = (imagenes != null && imagenes!.isNotEmpty)
        ? imagenes!
        : [imagen];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), 

      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left, 
            size: 30
          ),
        ),
        title: Text(
          nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritosScreen(),
              ),
              );
            },
            icon: const Icon(Icons.favorite_border),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProductoInfoCard(
              imagenes: listaImagenes,
              nombre: nombre,
              precio: precio,
              sku: sku ?? '04511214121451',
              puntuacion: puntuacion ?? 4.5,
              comentarios: comentarios ?? 15,
              disponibles: disponibles ?? 10,
            ),

            const SizedBox(height: 16),

       
            const DescripcionCard(
              descripcion:
                  'Martillo profesional diseñado para trabajos de construcción y carpintería. Cuenta con un mango cómodo de hule ergonómico y una cabeza de acero de alta resistencia.',
            ),

            const SizedBox(height: 16),

            const EspecificacionesCard(
              marca: 'SURTEK',
              modelo: '420X',
              especificaciones: [
                'Peso: 20 oz',
                'Material: Acero forjado',
                'Mango: Hule antiderrapante',
                'Garantía: 1 año con fabricante',
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$nombre agregado al carrito',
                        style: GoogleFonts.nunito(),
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF2971A4),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Agregar al carrito',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73C2FB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}