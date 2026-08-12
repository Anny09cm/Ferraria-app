import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriaCard extends StatelessWidget {
  final String imagen;
  final String categoria;

  const CategoriaCard({
    super.key,
    required this.imagen,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: const Color.fromARGB(255, 175, 180, 165),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 110, 
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.contain, 
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Center(
                child: Text(
                  categoria,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 16, 
                    color: Colors.black87,
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