import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/widgets/customsearch_bar.dart'; 
import 'package:ferraria/widgets/filtro_button.dart'; // Botón de filtro
import 'package:ferraria/widgets/producto_card.dart';
import 'package:ferraria/screens/producto_especifico_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _todosLosProductos = [
    {
      "nombre": "Martillo de mango recto",
      "imagen": "assets/images/martillo.png",
      "precio": "MXN 320",
      "puntuacion": "4.8",
      "comentarios": "15",
    },
    {
      "nombre": "Destornillador de cruz",
      "imagen": "assets/images/destornillador.png",
      "precio": "MXN 135",
      "puntuacion": "4.5",
      "comentarios": "8",
    },
    {
      "nombre": "Alicate de corte diagonal", 
      "imagen": "assets/images/alicate.png",
      "precio": "MXN 190",
      "puntuacion": "4.6",
      "comentarios": "12",
    },
    {
      "nombre": "Taladro inalámbrico",
      "imagen": "assets/images/taladro.png",
      "precio": "MXN 850",
      "puntuacion": "5.0",
      "comentarios": "30",
    },
  ];

  List<Map<String, String>> _productosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _productosFiltrados = _todosLosProductos;
  }

  void _filtrarProductos(String consulta) {
    setState(() {
      if (consulta.isEmpty) {
        _productosFiltrados = _todosLosProductos;
      } else {
        _productosFiltrados = _todosLosProductos
            .where((producto) => producto["nombre"]!
                .toLowerCase()
                .contains(consulta.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const SizedBox(height: 15),

              // =========================
              // BÚSQUEDA + FILTRO
              // =========================
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      hintText: 'Buscar producto...',
                      controller: _searchController,
                      onChanged: _filtrarProductos,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const FiltroButton(), // Se agrega el botón de filtro al lado
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // RESULTADOS DE BÚSQUEDA
              // =========================
              Expanded(
                child: _productosFiltrados.isEmpty
                    ? Center(
                        child: Text(
                          'No se encontraron productos para "${_searchController.text}"',
                          style: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          mainAxisExtent: 200,
                        ),
                        itemCount: _productosFiltrados.length,
                        itemBuilder: (context, index) {
                          final producto = _productosFiltrados[index];
                          
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductoEspecificoScreen(
                                    nombre: producto["nombre"]!,
                                    precio: producto["precio"]!,
                                    imagen: producto["imagen"]!,
                                  ),
                                ),
                              );
                            },
                            child: ProductoCard(
                              imagen: producto["imagen"] ?? '',
                              nombre: producto["nombre"] ?? '',
                              precio: producto["precio"],
                              puntuacion: double.tryParse(
                                producto["puntuacion"] ?? '0.0',
                              ),
                              comentarios: int.tryParse(
                                    producto["comentarios"] ?? '0',
                                  ) ??
                                  0,
                              onAddToCart: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      textAlign: TextAlign.center,
                                      '${producto["nombre"]} agregado al carrito',
                                      style: GoogleFonts.nunito(),
                                    ),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xFF73C2FB),
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
      ),
    );
  }
}