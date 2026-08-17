import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductoCard extends StatelessWidget {
  final String imagen;
  final String nombre;
  final String? precio;
  final String? marca;
  final String? sku;
  final double? puntuacion;
  final int comentarios;
  final bool agregando;
  final VoidCallback? onAddToCart;

  const ProductoCard({
    super.key,
    required this.imagen,
    required this.nombre,
    this.precio,
    this.marca,
    this.sku,
    this.puntuacion,
    this.comentarios = 0,
    this.agregando = false,
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
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 35,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                nombre,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (precio != null && precio!.isNotEmpty)
              Text(
                precio!,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF73C2FB),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ESTRELLAS
                if (puntuacion != null && puntuacion! > 0)
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFB800),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          puntuacion!.toStringAsFixed(1),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '($comentarios)',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const Spacer(),
                if (onAddToCart != null || agregando)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: agregando ? null : onAddToCart,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: agregando
                              ? Colors.grey.shade400
                              : const Color(0xFF73C2FB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: agregando
                            ? const Padding(
                                padding: EdgeInsets.all(9),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
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