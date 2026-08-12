import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/favoritos_screen.dart';
import 'package:ferraria/widgets/favoritos.dart'; 
import 'package:ferraria/widgets/informacion_producto_card.dart';
import 'package:ferraria/widgets/descripcion_card.dart';
import 'package:ferraria/widgets/especificaciones_card.dart';

class ProductoEspecificoScreen extends StatefulWidget {
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
  State<ProductoEspecificoScreen> createState() => _ProductoEspecificoScreenState();
}

class _ProductoEspecificoScreenState extends State<ProductoEspecificoScreen> {

  bool esFavorito = false;

  @override
  void initState() {
    super.initState();

    esFavorito = FavoritosService.esFavorito(widget.nombre);
  }

  @override
  Widget build(BuildContext context) {
    final listaImagenes = (widget.imagenes != null && widget.imagenes!.isNotEmpty)
        ? widget.imagenes!
        : [widget.imagen];

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
            size: 30,
          ),
        ),
        title: Text(
          widget.nombre,
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
              setState(() {
                esFavorito = !esFavorito;

                if (esFavorito) {
                  // Agregar al servicio global de favoritos
                  FavoritosService.agregar({
                    'nombre': widget.nombre,
                    'precio': widget.precio,
                    'imagen': widget.imagen,
                  });
                } else {
                  // Remover del servicio global
                  FavoritosService.eliminar(widget.nombre);
                }
              });

              // Mostrar SnackBar al usuario
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    esFavorito
                        ? 'Agregado a tus favoritos'
                        : 'Removido de favoritos',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                    ),
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: esFavorito ? Color(0xFF73C2FB) : const Color(0xFF73C2FB),
                  action: SnackBarAction(
                    label: 'Ver',
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoritosScreen()),
                      );
                    },
                  ),
                ),
              );
            },
            icon: Icon(
              esFavorito ? Icons.favorite : Icons.favorite_border,
              color: esFavorito ? Colors.white : Colors.white,
            ),
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
              nombre: widget.nombre,
              precio: widget.precio,
              sku: widget.sku ?? '04511214121451',
              puntuacion: widget.puntuacion ?? 4.5,
              comentarios: widget.comentarios ?? 15,
              disponibles: widget.disponibles ?? 10,
            ),

            const SizedBox(height: 16),

            const DescripcionCard(
              descripcion:
              'Diseñado para ofrecer un equilibrio perfecto entre potencia y control, permite clavar, ajustar y retirar clavos con facilidad gracias a su uña curva de alta resistencia. Fabricado con materiales duraderos y un diseño ergonómico, este martillo proporciona un agarre cómodo y seguro, reduciendo la fatiga durante jornadas de trabajo prolongadas. Ideal tanto para uso profesional como para proyectos de bricolaje (DIY).',
            ),

            const SizedBox(height: 16),

            const EspecificacionesCard(
              marca: 'Wilson',
              modelo: '420X',
              especificaciones: [
                'Peso: 16 oz',
                'Material: Acero forjado',
                'Mango: Hule antiderrapante',
                'Garantía: 1 año con fabricante',
              ],
            ),

            const SizedBox(height: 24),

            // BOTÓN AGREGAR AL CARRITO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.nombre} agregado al carrito',
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