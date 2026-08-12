import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GrupoCard extends StatelessWidget {
  final String imagen;
  final String nombre;

  const GrupoCard({
    super.key,
    required this.imagen,
    required this.nombre,
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imagen,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              nombre,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}