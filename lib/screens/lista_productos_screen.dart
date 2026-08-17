import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ferraria/screens/producto_especifico_screen.dart';
import 'package:ferraria/screens/favoritos_screen.dart';
import 'package:ferraria/services/cart_favorites_service.dart';
import 'package:ferraria/widgets/producto_card.dart';
import 'package:ferraria/widgets/customsearch_bar.dart';
import 'package:ferraria/widgets/filtro_button.dart';

class ListaProductosScreen extends StatefulWidget {
  final String tipo;
  final VoidCallback? onIrAlCarrito;
  final bool esVendedor;

  const ListaProductosScreen({
    super.key,
    required this.tipo,
    this.onIrAlCarrito,
    this.esVendedor = false,
  });

  @override
  State<ListaProductosScreen> createState() => _ListaProductosScreenState();
}

class _ListaProductosScreenState extends State<ListaProductosScreen> {
  late TextEditingController searchController;
  String _filtroBusqueda = '';

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

  Future<void> _cambiarFavorito(Map<String, dynamic> producto) async {
    if (widget.esVendedor) {
      return;
    }

    try {
      final agregado = await CartFavoritesService.toggleFavorito(producto);

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            agregado
                ? '${producto["nombre"]} agregado a favoritos'
                : '${producto["nombre"]} eliminado de favoritos',
            style: GoogleFonts.nunito(),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2971A4),
        ),
      );

      setState(() {});
    } catch (_) {}
  }

  Future<void> _agregarCarrito(Map<String, dynamic> producto) async {
    if (widget.esVendedor) {
      return;
    }

    try {
      await CartFavoritesService.agregarAlCarrito(producto);

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${producto["nombre"]} agregado al carrito 🛒',
            style: GoogleFonts.nunito(),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2971A4),
        ),
      );
    } catch (_) {}
  }

  void _irAlCarrito() {
    if (widget.esVendedor) {
      return;
    }

    if (widget.onIrAlCarrito == null) {
      return;
    }

    widget.onIrAlCarrito!();

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (!widget.esVendedor)
            IconButton(
              onPressed: _irAlCarrito,
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
          if (!widget.esVendedor)
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
          if (!widget.esVendedor)
            const SizedBox(width: 5),
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
                    hintText: 'Buscar ${widget.tipo.toLowerCase()}...',
                    controller: searchController,
                    onChanged: (texto) {
                      setState(() {
                        _filtroBusqueda = texto.toLowerCase();
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
                stream: FirebaseFirestore.instance
                    .collection('productos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF73C2FB),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  List<QueryDocumentSnapshot> productosFiltrados =
                      docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final categoria =
                        data['categoria']?.toString().toLowerCase() ?? '';
                    final subcategoria =
                        data['subcategoria']?.toString().toLowerCase() ?? '';
                    final marca =
                        data['marca']?.toString().toLowerCase() ?? '';

                    final tipoBuscado = widget.tipo.toLowerCase();

                    return categoria == tipoBuscado ||
                        subcategoria == tipoBuscado ||
                        marca == tipoBuscado;
                  }).toList();

                  if (_filtroBusqueda.isNotEmpty) {
                    productosFiltrados = productosFiltrados
                        .where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final nombre =
                          data['nombre']?.toString().toLowerCase() ?? '';

                      return nombre.contains(_filtroBusqueda);
                    }).toList();
                  }

                  if (productosFiltrados.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay productos disponibles.',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      mainAxisExtent: 245,
                    ),
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final producto = productosFiltrados[index].data() as Map<String, dynamic>;
                      final nombre = producto['nombre']?.toString() ?? '';
                      final imagen = producto['imagen']?.toString() ?? '';
                      final precio = producto['precio']?.toString() ?? '';
                      final marca = producto['marca']?.toString() ?? 'Genérico';
                      final sku = producto['sku']?.toString() ?? '';
                      final disponibles = int.tryParse(producto['disponibles']?.toString() ?? '0', ) ?? 0;
                      final puntuacion = double.tryParse(producto['puntuacion']?.toString() ?? '0',) ?? 0.0;
                      final comentarios = int.tryParse(producto['comentarios']?.toString() ?? '0',) ?? 0;

                      return Stack(
                        children: [
                          GestureDetector(
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
                                    sku: sku,
                                    disponibles: disponibles,
                                    imagenes: (producto['imagenes']
                                            as List<dynamic>?)
                                        ?.cast<String>(),
                                    puntuacion: puntuacion,
                                    comentarios: comentarios,
                                    descripcion:
                                        producto['descripcion']?.toString(),
                                    modelo:
                                        producto['modelo']?.toString(),
                                    especificaciones:
                                        (producto['especificaciones']
                                                as List<dynamic>?)
                                            ?.cast<String>(),
                                  ),
                                ),
                              );
                            },
                            child: ProductoCard(
                              imagen: imagen,
                              nombre: nombre,
                              precio: precio,
                              marca: marca,
                              puntuacion: puntuacion,
                              comentarios: comentarios,
                              onAddToCart: widget.esVendedor
                                  ? null
                                  : () => _agregarCarrito(producto),
                            ),
                          ),
                          if (!widget.esVendedor)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: FutureBuilder<bool>(
                                future: CartFavoritesService.esFavorito(
                                  sku.isNotEmpty ? sku : nombre,
                                ),
                                builder: (context, favSnapshot) {
                                  final esFavorito = favSnapshot.data ?? false;

                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      onPressed: () =>
                                          _cambiarFavorito(producto),
                                      icon: Icon(
                                        esFavorito
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: const Color(0xFF73C2FB),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
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