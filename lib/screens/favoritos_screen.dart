import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ferraria/services/cart_favorites_service.dart';
import 'package:ferraria/widgets/producto_card.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final Set<String> _procesando = {};

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
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
        ),
        title: Text(
          'Favoritos',
          style: GoogleFonts.nunito(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: CartFavoritesService.obtenerFavoritosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF73C2FB),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No se pudieron cargar tus favoritos.',
                style: GoogleFonts.nunito(
                  color: Colors.grey,
                ),
              ),
            );
          }

          final favoritos = snapshot.data?.docs ?? [];

          if (favoritos.isEmpty) {
            return Center(
              child: Text(
                'No tienes productos favoritos.',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                mainAxisExtent: 240,
              ),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final doc = favoritos[index];
                final producto = doc.data();
                final id = doc.id;
                final sku = producto['sku']?.toString().trim() ?? id;
                final nombre = producto['nombre']?.toString() ?? '';
                final puntuacion = (producto['puntuacion'] as num?)?.toDouble() ?? 0.0;
                final comentarios = (producto['comentarios'] as num?)?.toInt() ?? 0;
                final estaProcesando = _procesando.contains(id);

                return Stack(
                  children: [
                    // =========================================
                    // CARD
                    // =========================================
                    ProductoCard(
                      imagen: producto['imagen']?.toString() ?? '',
                      nombre: nombre,
                      precio: producto['precio']?.toString() ?? '',
                      marca: producto['marca']?.toString(),
                      sku: sku,
                      puntuacion: puntuacion,
                      comentarios: comentarios,
                      agregando: estaProcesando,
                      onAddToCart: () async {
                        if (estaProcesando) return;

                        setState(() {
                          _procesando.add(id);
                        });

                        try {
                          await CartFavoritesService.agregarAlCarrito(producto);
                          _mostrarMensaje('$nombre agregado al carrito');
                        } catch (e) {
                          _mostrarMensaje('No se pudo agregar al carrito.');
                        } finally {
                          if (mounted) {
                            setState(() {
                              _procesando.remove(id);
                            });
                          }
                        }
                      },
                    ),

                    // =========================================
                    // CORAZÓN FAVORITO
                    // =========================================
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {}, // ESTA LÍNEA ES LA MAGIA QUE ABSORBE EL TOQUE
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 34,
                            minHeight: 34,
                          ),
                          onPressed: estaProcesando
                              ? null
                              : () async {
                                  setState(() {
                                    _procesando.add(id);
                                  });

                                  try {
                                    await CartFavoritesService.eliminarFavorito(sku);
                                    _mostrarMensaje('Eliminado de favoritos');
                                  } catch (e) {
                                    _mostrarMensaje('No se pudo eliminar.');
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _procesando.remove(id);
                                      });
                                    }
                                  }
                                },
                          icon: estaProcesando
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF73C2FB),
                                  ),
                                )
                              : const Icon(
                                  Icons.favorite,
                                  color: Color(0xFF73C2FB),
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}