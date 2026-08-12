import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/producto_especifico_screen.dart';
import 'package:ferraria/screens/favoritos_screen.dart';
import 'package:ferraria/widgets/producto_card.dart';
import 'package:ferraria/widgets/customsearch_bar.dart';
import 'package:ferraria/widgets/filtro_button.dart';

class ListaProductosScreen extends StatefulWidget {
  final String tipo;

  const ListaProductosScreen({
    super.key,
    required this.tipo,
  });

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  late TextEditingController searchController;
  String _filtroBusqueda = "";

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> obtenerProductos() {
    List<Map<String, dynamic>> todos = [];

    if (widget.tipo == "Martillos") {
      todos = [
        {
          "nombre": "Martillo con agarre curvo 16oz",
          "precio": "MXN 349",
          "imagen": "assets/images/martilloagarrecurvo1.png",
          "imagenes": [
            "assets/images/martilloagarrecurvo1.png",
            "assets/images/martilloagarrecurvo2.png",
            "assets/images/martilloagarrecurvo3.png",
            "assets/images/martilloagarrecurvo4.png",
          ],
          "puntuacion": "4.8",
          "comentarios": "24",
        },
        {
          "nombre": "Martillo de uña",
          "precio": "MXN 280",
          "imagen": "assets/images/martillo.png",
          "puntuacion": "4.5",
          "comentarios": "15",
        },
        {
          "nombre": "Martillo de bola",
          "precio": "MXN 320",
          "imagen": "assets/images/martillo.png",
          "puntuacion": "4.9",
          "comentarios": "38",
        },
      ];
    } else if (widget.tipo == "Destornilladores") {
      todos = [
        {
          "nombre": "Destornillador plano",
          "precio": "MXN 120",
          "imagen": "assets/images/destornillador.png",
          "puntuacion": "4.3",
          "comentarios": "10",
        },
        {
          "nombre": "Destornillador de cruz",
          "precio": "MXN 135",
          "imagen": "assets/images/destornillador.png",
          "puntuacion": "4.7",
          "comentarios": "18",
        },
      ];
    } else if (widget.tipo == "Alicates") {
      todos = [
        {
          "nombre": "Alicate universal",
          "precio": "MXN 190",
          "imagen": "assets/images/alicate.png",
          "puntuacion": "4.6",
          "comentarios": "12",
        },
      ];
    } else if (widget.tipo == "Taladros") {
      todos = [
        {
          "nombre": "Taladro eléctrico",
          "precio": "MXN 850",
          "imagen": "assets/images/taladro.png",
          "puntuacion": "5.0",
          "comentarios": "45",
        },
      ];
    } else if (widget.tipo == "Llaves") {
      todos = [
        {
          "nombre": "Juego de Llaves Combinadas",
          "precio": "MXN 480",
          "imagen": "assets/images/juego.png",
          "puntuacion": "4.5",
          "comentarios": "12",
        }
      ];
    }

    if (_filtroBusqueda.isNotEmpty) {
      return todos
          .where((p) => p["nombre"]
              .toString()
              .toLowerCase()
              .contains(_filtroBusqueda.toLowerCase()))
          .toList();
    }

    return todos;
  }

  @override
  Widget build(BuildContext context) {
    final productos = obtenerProductos();

    return Scaffold(
      backgroundColor: Colors.white,
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
            size: 32,
          ),
        ),
        title: Text(
          widget.tipo,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritosScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    hintText: "Buscar ${widget.tipo.toLowerCase()}...",
                    controller: searchController,
                    onChanged: (texto) {
                      setState(() {
                        _filtroBusqueda = texto;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const FiltroButton(),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: productos.isEmpty
                  ? Center(
                      child: Text(
                        "No hay productos disponibles.",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 220, // Ajustado a 220 para que quepa bien ProductoCard
                      ),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];

                        return GestureDetector(
                          onTap: () {
                            // NAVEGACIÓN ENVIANDO LISTA DE IMÁGENES
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductoEspecificoScreen(
                                  nombre: producto["nombre"].toString(),
                                  precio: producto["precio"].toString(),
                                  imagen: producto["imagen"].toString(),
                                  imagenes: (producto["imagenes"] as List<dynamic>?)
                                      ?.cast<String>(), // 👈 Envía la lista de imágenes
                                  puntuacion: double.tryParse(
                                    producto["puntuacion"]?.toString() ?? '0.0',
                                  ),
                                  comentarios: int.tryParse(
                                    producto["comentarios"]?.toString() ?? '0',
                                  ),
                                ),
                              ),
                            );
                          },
                          child: ProductoCard(
                            imagen: producto["imagen"]?.toString() ?? '',
                            nombre: producto["nombre"]?.toString() ?? '',
                            precio: producto["precio"]?.toString(),
                            puntuacion: double.tryParse(
                              producto["puntuacion"]?.toString() ?? '0.0',
                            ),
                            comentarios: int.tryParse(
                                  producto["comentarios"]?.toString() ?? '0',
                                ) ??
                                0,
                            onAddToCart: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${producto["nombre"]} agregado al carrito',
                                    style: GoogleFonts.nunito(),
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF2971A4),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}