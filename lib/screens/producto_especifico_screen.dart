import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/carrito_screen.dart';
import 'package:ferraria/services/cart_favorites_service.dart';

import 'package:ferraria/widgets/informacion_producto_card.dart';
import 'package:ferraria/widgets/descripcion_card.dart';
import 'package:ferraria/widgets/especificaciones_card.dart';

class ProductoEspecificoScreen extends StatefulWidget {
  final String nombre;
  final String precio;
  final String marca;
  final String imagen;

  final List<String>? imagenes;

  final String? sku;
  final double? puntuacion;
  final int? comentarios;
  final int? disponibles;

  final String? descripcion;
  final String? modelo;

  final List<String>? especificaciones;

  // Callback para regresar al carrito del MainScreen
  final VoidCallback? onIrAlCarrito;

  const ProductoEspecificoScreen({
    super.key,
    required this.nombre,
    required this.precio,
    required this.marca,
    required this.imagen,
    this.imagenes,
    this.sku,
    this.puntuacion,
    this.comentarios,
    this.disponibles,
    this.descripcion,
    this.modelo,
    this.especificaciones,
    this.onIrAlCarrito,
  });

  @override
  State<ProductoEspecificoScreen> createState() =>
      _ProductoEspecificoScreenState();
}

class _ProductoEspecificoScreenState extends State<ProductoEspecificoScreen> {
  bool _esFavorito = false;
  bool _procesandoFavorito = false;
  bool _agregandoCarrito = false;

  @override
  void initState() {
    super.initState();
    _cargarFavorito();
  }

  // =========================================================
  // CREAR PRODUCTO
  // =========================================================

  Map<String, dynamic> _crearProducto() {
    return {
      'sku': widget.sku?.trim() ?? '',
      'nombre': widget.nombre,
      'precio': widget.precio,
      'marca': widget.marca,
      'imagen': widget.imagen,
      'imagenes': widget.imagenes ?? [],
      'puntuacion': widget.puntuacion ?? 0.0,
      'comentarios': widget.comentarios ?? 0,
      'disponibles': widget.disponibles ?? 0,
      'descripcion': widget.descripcion ?? '',
      'modelo': widget.modelo ?? '',
      'especificaciones': widget.especificaciones ?? [],
    };
  }

  // =========================================================
  // CARGAR FAVORITO
  // =========================================================

  Future<void> _cargarFavorito() async {
    final sku = widget.sku?.trim() ?? '';

    if (sku.isEmpty) return;

    try {
      final resultado = await CartFavoritesService.esFavorito(sku);

      if (!mounted) return;

      setState(() {
        _esFavorito = resultado;
      });
    } catch (_) {
      // No mostramos error innecesario en pantalla.
    }
  }

  // =========================================================
  // MENSAJE
  // =========================================================

  void _mostrarMensaje(String mensaje) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            mensaje,
            style: GoogleFonts.nunito(),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2971A4),
        ),
      );
  }

  // =========================================================
  // IR AL CARRITO
  // =========================================================

  void _irAlCarrito() {
    // Si venimos desde MainScreen,
    // usamos el carrito del navbar.
    if (widget.onIrAlCarrito != null) {
      widget.onIrAlCarrito!();

      Navigator.popUntil(
        context,
        (route) => route.isFirst,
      );

      return;
    }

    // Si la pantalla se abrió de otra forma,
    // abrimos el carrito normalmente.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarritoScreen(),
      ),
    );
  }

  // =========================================================
  // FAVORITO
  // =========================================================

  Future<void> _toggleFavorito() async {
    if (_procesandoFavorito) return;

    final sku = widget.sku?.trim() ?? '';

    if (sku.isEmpty) {
      _mostrarMensaje('Este producto no tiene un SKU válido.');
      return;
    }

    setState(() {
      _procesandoFavorito = true;
    });

    try {
      final resultado = await CartFavoritesService.toggleFavorito(
        _crearProducto(),
      );

      if (!mounted) return;

      setState(() {
        _esFavorito = resultado;
      });

      _mostrarMensaje(
        resultado ? 'Agregado a favoritos' : 'Eliminado de favoritos',
      );
    } catch (_) {
      _mostrarMensaje(
        'No se pudo actualizar favoritos.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _procesandoFavorito = false;
        });
      }
    }
  }

  // =========================================================
  // CARRITO
  // =========================================================

  Future<void> _agregarCarrito() async {
    if (_agregandoCarrito) return;

    final sku = widget.sku?.trim() ?? '';

    if (sku.isEmpty) {
      _mostrarMensaje(
        'Este producto no tiene un SKU válido.',
      );
      return;
    }

    setState(() {
      _agregandoCarrito = true;
    });

    try {
      await CartFavoritesService.agregarAlCarrito(
        _crearProducto(),
      );

      if (!mounted) return;

      _mostrarMensaje(
        '${widget.nombre} agregado al carrito',
      );
    } catch (_) {
      _mostrarMensaje(
        'No se pudo agregar el producto al carrito.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _agregandoCarrito = false;
        });
      }
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final listaImagenes =
        widget.imagenes != null && widget.imagenes!.isNotEmpty
            ? widget.imagenes!
            : [widget.imagen];

    final skuMostrar = widget.sku?.trim().isNotEmpty == true
        ? widget.sku!.trim()
        : 'Sin SKU';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
          // =================================================
          // CARRITO
          // =================================================

          IconButton(
            onPressed: _irAlCarrito,
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),

          // =================================================
          // FAVORITO
          // =================================================

          IconButton(
            onPressed: _procesandoFavorito ? null : _toggleFavorito,
            icon: _procesandoFavorito
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    _esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      // =====================================================
      // CONTENIDO
      // =====================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProductoInfoCard(
              imagenes: listaImagenes,
              nombre: widget.nombre,
              precio: widget.precio,
              sku: skuMostrar,
              puntuacion: widget.puntuacion ?? 0.0,
              comentarios: widget.comentarios ?? 0,
              disponibles: widget.disponibles ?? 0,
            ),
            const SizedBox(height: 16),
            DescripcionCard(
              descripcion: widget.descripcion ??
                  'Producto de alta calidad para ferretería y construcción. Diseñado para ofrecer durabilidad, gran resistencia y excelente rendimiento en cualquier proyecto.',
            ),
            const SizedBox(height: 16),
            EspecificacionesCard(
              marca: widget.marca,
              modelo: widget.modelo ?? 'Sin modelo',
              especificaciones: widget.especificaciones ??
                  const [
                    'Uso industrial y doméstico',
                    'Material de alta resistencia',
                    'Garantía: 1 año con fabricante',
                  ],
            ),
            const SizedBox(height: 24),

            // =================================================
            // BOTÓN AGREGAR AL CARRITO
            // =================================================

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _agregandoCarrito ? null : _agregarCarrito,
                icon: _agregandoCarrito
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                label: Text(
                  _agregandoCarrito ? 'Agregando...' : 'Agregar al carrito',
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF73C2FB),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}