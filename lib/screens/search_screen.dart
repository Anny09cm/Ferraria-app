import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ferraria/widgets/customsearch_bar.dart';
import 'package:ferraria/widgets/filtro_button.dart';
import 'package:ferraria/widgets/producto_card.dart';
import 'package:ferraria/screens/producto_especifico_screen.dart';
import 'package:ferraria/services/cart_favorites_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroTexto = '';
  final Set<String> _agregando = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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


  Map<String, dynamic> _crearProducto(Map<String, dynamic> producto) {
    return {
      'sku': producto['sku']?.toString().trim() ?? '',
      'nombre': producto['nombre']?.toString() ?? '',
      'precio': producto['precio']?.toString() ?? '',
      'marca': producto['marca']?.toString() ?? '',
      'imagen': producto['imagen']?.toString() ?? '',
      'imagenes': (producto['imagenes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      'puntuacion': double.tryParse(producto['puntuacion']?.toString() ?? '0') ?? 0.0,
      'comentarios': int.tryParse(producto['comentarios']?.toString() ?? '0') ?? 0,
      'disponibles': int.tryParse(producto['disponibles']?.toString() ?? '0') ?? 0,
      'descripcion': producto['descripcion']?.toString() ?? '',
      'modelo': producto['modelo']?.toString() ?? '',
      'especificaciones': (producto['especificaciones'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    };
  }

  Future<void> _agregarAlCarrito(Map<String, dynamic> producto, String idProducto) async {
    if (_agregando.contains(idProducto)) return;

    final productoCompleto = _crearProducto(producto);
    final sku = productoCompleto['sku'].toString().trim();

    if (sku.isEmpty) {
      _mostrarMensaje('Este producto no tiene un SKU válido.');
      return;
    }

    setState(() {
      _agregando.add(idProducto);
    });

    try {
      await CartFavoritesService.agregarAlCarrito(productoCompleto);
      _mostrarMensaje('${productoCompleto['nombre']} agregado al carrito');
    } catch (e) {
      _mostrarMensaje('No se pudo agregar el producto al carrito.');
    } finally {
      if (mounted) {
        setState(() {
          _agregando.remove(idProducto);
        });
      }
    }
  }

  void _abrirProducto(Map<String, dynamic> producto) {
    final productoCompleto = _crearProducto(producto);
    final sku = productoCompleto['sku'].toString().trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductoEspecificoScreen(
          nombre: productoCompleto['nombre'],
          precio: productoCompleto['precio'],
          marca: productoCompleto['marca'],
          imagen: productoCompleto['imagen'],
          sku: sku.isEmpty ? null : sku,
          imagenes: productoCompleto['imagenes'],
          puntuacion: productoCompleto['puntuacion'],
          comentarios: productoCompleto['comentarios'],
          disponibles: productoCompleto['disponibles'],
          descripcion: productoCompleto['descripcion'],
          modelo: productoCompleto['modelo'],
          especificaciones: productoCompleto['especificaciones'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      hintText: 'Buscar producto...',
                      controller: _searchController,
                      onChanged: (texto) {
                        setState(() {
                          _filtroTexto = texto;
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('productos').snapshots(),
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
                          'Error al consultar productos',
                          style: GoogleFonts.nunito(
                            color: Color(0xFF2971A4),
                          ),
                        ),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final consulta = _filtroTexto.toLowerCase().trim();
                    final resultados = docs.where((doc) {
                      final producto = doc.data() as Map<String, dynamic>;
                      final nombre = producto['nombre']?.toString().toLowerCase() ?? '';
                      final marca = producto['marca']?.toString().toLowerCase() ?? '';
                      final sku = producto['sku']?.toString().toLowerCase() ?? '';

                      return nombre.contains(consulta) || marca.contains(consulta) || sku.contains(consulta);
                    }).toList();

                    if (resultados.isEmpty) {
                      return Center(
                        child: Text(
                          consulta.isEmpty
                              ? 'Escribe algo para buscar productos'
                              : 'No se encontraron productos para "$_filtroTexto"',
                          style: GoogleFonts.nunito(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        mainAxisExtent: 230,
                      ),
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final doc = resultados[index];
                        final producto = doc.data() as Map<String, dynamic>;
                        final idProducto = doc.id;

                        final puntuacion = double.tryParse(producto['puntuacion']?.toString() ?? '0') ?? 0.0;
                        final comentarios = int.tryParse(producto['comentarios']?.toString() ?? '0') ?? 0;
                        final estaAgregando = _agregando.contains(idProducto);

                        return GestureDetector(
                          onTap: () => _abrirProducto(producto),
                          child: ProductoCard(
                            imagen: producto['imagen']?.toString() ?? '',
                            nombre: producto['nombre']?.toString() ?? '',
                            precio: producto['precio']?.toString(),
                            marca: producto['marca']?.toString(),
                            sku: producto['sku']?.toString(),
                            puntuacion: puntuacion,
                            comentarios: comentarios,
                            agregando: estaAgregando,
                            onAddToCart: () => _agregarAlCarrito(producto, idProducto),
                          ),
                        );
                      },
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