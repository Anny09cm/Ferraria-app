import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EspecificacionesCard extends StatelessWidget {
  final String modelo;
  final String marca;
  final List<String> especificaciones;

  const EspecificacionesCard({
    super.key,
    required this.modelo,
    required this.marca,
    required this.especificaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(112, 43, 42, 42),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Especificaciones',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Marca y Modelo en filas alineadas
            _construirFila('Marca', marca),
            _construirFila('Modelo', modelo),

            if (especificaciones.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(color: Color(0xFFE0E0E0), thickness: 1),
              const SizedBox(height: 8),

              ...especificaciones.map(
                (especificacion) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFF73C2FB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          especificacion,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _construirFila(String clave, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            clave,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            valor,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}