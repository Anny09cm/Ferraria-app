import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductoInfoCard extends StatefulWidget {
  final List<String> imagenes; // Lista de imágenes para el carrusel
  final String nombre;
  final String precio;
  final String sku;
  final double puntuacion;
  final int comentarios;
  final int disponibles;

  const ProductoInfoCard({
    super.key,
    required this.imagenes,
    required this.nombre,
    required this.precio,
    required this.sku,
    required this.puntuacion,
    required this.comentarios,
    required this.disponibles,
  });

  @override
  State<ProductoInfoCard> createState() => _ProductoInfoCardState();
}

class _ProductoInfoCardState extends State<ProductoInfoCard> {
  int _paginaActual = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(112, 43, 42, 42),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. IMAGEN / CARRUSEL
            SizedBox(
              height: 120,
              width: double.infinity,
              child: widget.imagenes.isEmpty
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 40,
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: widget.imagenes.length,
                      onPageChanged: (index) {
                        setState(() {
                          _paginaActual = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.asset(
                          widget.imagenes[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            // 2. PUNTOS DEL CARRUSEL
            if (widget.imagenes.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imagenes.length, (index) {
                  final estaActivo = _paginaActual == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: estaActivo ? 10 : 8,
                    height: estaActivo ? 10 : 8,
                    decoration: BoxDecoration(
                      color: estaActivo
                          ? const Color(0xFFFFC107) 
                          : const Color(0xFFC4C4C4), 
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),

            const SizedBox(height: 16),

            // 3. NOMBRE
            Text(
              widget.nombre,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // 4. DIVISOR
            const Divider(
              color: Color(0xFFE0E0E0),
              thickness: 1,
              height: 1,
            ),

            const SizedBox(height: 12),

            // 5. SECCIÓN INFERIOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.precio,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'SKU ${widget.sku}',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(112, 43, 42, 42),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: index < widget.puntuacion.floor()
                                    ? const Color(0xFFFFC107)
                                    : const Color(0xFFE0E0E0),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '(${widget.comentarios})',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: const Color(0xFFB0B0B0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.disponibles} disponibles',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}