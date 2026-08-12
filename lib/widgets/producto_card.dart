import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductoCard extends StatelessWidget {
  final String imagen;
  final String nombre;
  final String? precio;
  final double? puntuacion;
  final int comentarios;
  final VoidCallback? onAddToCart; 

  const ProductoCard({
    super.key,
    required this.imagen,
    required this.nombre,
    this.precio,
    this.puntuacion,
    this.comentarios = 0,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: const Color.fromARGB(255, 175, 180, 165),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column( 
          // 1. Alinea todos los elementos de la columna a la izquierda
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            SizedBox(
              height: 85,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // 2. El nombre envuelto en Center para que sea el ÚNICO centrado
            Center(
              child: Text(
                nombre,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // 3. El precio ahora sí se recarga totalmente a la izquierda
            if (precio != null && precio!.isNotEmpty)
              Text(
                '$precio',
                style: GoogleFonts.nunito(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF73C2FB),
                ),
              ),

            const Spacer(),

            // 4. Fila inferior con Puntuación y Carrito
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (puntuacion != null && puntuacion! > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        puntuacion.toString(),
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '($comentarios)',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(), 

                if (onAddToCart != null)
                  InkWell(
                    onTap: onAddToCart,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73C2FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}