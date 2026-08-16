import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ferraria/screens/navbar_cliente.dart';
import 'package:ferraria/screens/lista_productos_screen.dart';
import 'package:ferraria/screens/producto_especifico_screen.dart';
import 'package:ferraria/widgets/marca_card.dart';
import 'package:ferraria/widgets/producto_card.dart';
import 'package:ferraria/services/cart_favorites_service.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onIrAlCarrito;

  const HomeScreen({
    super.key,
    this.onIrAlCarrito,
  });

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // MARCAS POPULARES
    // ============================================================

    final List<Map<String, String>> marcas = [
      {
        'nombre': 'Truper',
        'imagen': 'assets/images/truper.png',
      },
      {
        'nombre': 'DeWalt',
        'imagen': 'assets/images/dewalt.png',
      },
      {
        'nombre': 'Makita',
        'imagen': 'assets/images/makita.png',
      },
      {
        'nombre': 'Urrea',
        'imagen': 'assets/images/urrea.png',
      },
      {
        'nombre': 'Hermex',
        'imagen': 'assets/images/hermex.png',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // ==========================================================
      // DRAWER
      // ==========================================================

      drawer: const NavBarCliente(),

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            // ======================================================
            // OFERTAS DEL DÍA
            // ======================================================

            Text(
              '¡Ofertas del día!',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // CARRUSEL DE OFERTAS
            // ======================================================

            CarouselSlider(
              items: [
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Caja de Herramientas 19"',
                  precio: 'MXN 399',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Nivel de Gota Torpedo 9"',
                  precio: 'MXN 129',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Juego de Brocas para Concreto',
                  precio: 'MXN 289',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Pistola de Calor 1800W',
                  precio: 'MXN 649',
                ),
              ],
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
              ),
            ),

            const SizedBox(height: 30),

            // ======================================================
            // VOLVER A COMPRAR
            // ======================================================

            Text(
              'Volver a comprar',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // PRODUCTOS DESDE FIRESTORE
            // ======================================================

            SizedBox(
              height: 220,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('productos')
                    .limit(6)
                    .snapshots(),
                builder: (context, snapshot) {
                  // ------------------------------------------------
                  // CARGANDO
                  // ------------------------------------------------

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF73C2FB),
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // ERROR
                  // ------------------------------------------------

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar productos',
                        style: GoogleFonts.nunito(
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // DOCUMENTOS
                  // ------------------------------------------------

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay productos recientes',
                        style: GoogleFonts.nunito(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  // ------------------------------------------------
                  // LISTA HORIZONTAL
                  // ------------------------------------------------

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final prod =
                          docs[index].data() as Map<String, dynamic>;

                      final nombre =
                          prod["nombre"]?.toString() ?? '';

                      final precio =
                          prod["precio"]?.toString() ?? '';

                      final marca =
                          prod["marca"]?.toString() ?? 'Generico';

                      final imagen =
                          prod["imagen"]?.toString() ?? '';

                      final puntuacion =
                          double.tryParse(
                                prod["puntuacion"]?.toString() ??
                                    '0.0',
                              ) ??
                              0.0;

                      final comentarios =
                          int.tryParse(
                                prod["comentarios"]?.toString() ??
                                    '0',
                              ) ??
                              0;

                      final imagenes =
                          (prod["imagenes"] as List<dynamic>?)
                              ?.cast<String>();

                      final especificaciones =
                          (prod["especificaciones"]
                              as List<dynamic>?)
                              ?.cast<String>();

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                        ),
                        child: SizedBox(
                          width: 160,
                          child: GestureDetector(
                            // ==================================================
                            // ABRIR PRODUCTO
                            // ==================================================

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductoEspecificoScreen(
                                    nombre: nombre,
                                    precio: precio,
                                    marca: marca,
                                    imagen: imagen,
                                    imagenes: imagenes,
                                    puntuacion: puntuacion,
                                    comentarios: comentarios,
                                    descripcion:
                                        prod["descripcion"]
                                            ?.toString(),
                                    modelo:
                                        prod["modelo"]?.toString(),
                                    especificaciones:
                                        especificaciones,
                                  ),
                                ),
                              );
                            },

                            // ==================================================
                            // PRODUCT CARD
                            // ==================================================

                            child: ProductoCard(
                              imagen: imagen,
                              nombre: nombre,
                              precio: precio,
                              marca: prod['marca']?.toString(),
                              puntuacion: puntuacion,
                              comentarios: comentarios,

                              // ================================================
                              // AGREGAR AL CARRITO
                              // ================================================
                              //
                              // HomeScreen es para CLIENTES.
                              // Por eso el botón del carrito sí aparece.
                              //
                              // ================================================

                              onAddToCart: () async {
                                try {
                                  await CartFavoritesService
                                      .agregarAlCarrito(prod);

                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '$nombre agregado al carrito 🛒',
                                        style:
                                            GoogleFonts.nunito(),
                                      ),
                                      duration:
                                          const Duration(seconds: 2),
                                      behavior:
                                          SnackBarBehavior.floating,
                                      backgroundColor:
                                          const Color(0xFF2971A4),
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint(
                                    'Error al agregar al carrito: $e',
                                  );

                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No se pudo agregar al carrito',
                                        style:
                                            GoogleFonts.nunito(),
                                      ),
                                      duration:
                                          const Duration(seconds: 2),
                                      behavior:
                                          SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // MARCAS POPULARES
            // ======================================================

            Text(
              'Marcas populares',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // LISTA DE MARCAS
            // ======================================================

            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: marcas.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final marca = marcas[index];

                  return MarcaCard(
                    imagenPath: marca['imagen']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListaProductosScreen(
                            tipo: marca['nombre']!,
                            esVendedor: false,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ======================================================
            // ESPACIO FINAL
            // ======================================================

            SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom + 30,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET OFERTA
  // ============================================================

  Widget _crearOferta({
    required String imagen,
    required String nombre,
    required String precio,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // ========================================================
          // IMAGEN
          // ========================================================

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Image.asset(
                imagen,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ========================================================
          // INFORMACIÓN
          // ========================================================

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // OFERTA

                  Text(
                    'OFERTA',
                    style: GoogleFonts.nunito(
                      color: const Color(0xFF73C2FB),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // NOMBRE

                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // PRECIO

                  Text(
                    precio,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: const Color(0xFF73C2FB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}