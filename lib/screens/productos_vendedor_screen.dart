import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductosVendedorScreen extends StatefulWidget {
  const ProductosVendedorScreen({super.key});

  @override
  State<ProductosVendedorScreen> createState() =>
      _ProductosVendedorScreenState();
}

class _ProductosVendedorScreenState
    extends State<ProductosVendedorScreen> {
  static const Color azul = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);

  final _formKey = GlobalKey<FormState>();

  final _skuController = TextEditingController();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _marcaController = TextEditingController();
  final _imagenController = TextEditingController();
  final _imagenesController = TextEditingController();
  final _disponiblesController = TextEditingController();
  final _puntuacionController = TextEditingController();
  final _comentariosController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _modeloController = TextEditingController();
  final _especificacionesController = TextEditingController();

  bool _guardando = false;

  @override
  void dispose() {
    _skuController.dispose();
    _nombreController.dispose();
    _precioController.dispose();
    _marcaController.dispose();
    _imagenController.dispose();
    _imagenesController.dispose();
    _disponiblesController.dispose();
    _puntuacionController.dispose();
    _comentariosController.dispose();
    _descripcionController.dispose();
    _modeloController.dispose();
    _especificacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final sku = _skuController.text.trim();

      // Comprobar que el SKU no exista.
      final existente = await FirebaseFirestore.instance
          .collection('productos')
          .where('sku', isEqualTo: sku)
          .limit(1)
          .get();

      if (existente.docs.isNotEmpty) {
        _mostrarMensaje(
          'Ya existe un producto con ese SKU.',
          Colors.redAccent,
        );

        setState(() {
          _guardando = false;
        });

        return;
      }

      final imagenes = _imagenesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final especificaciones = _especificacionesController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await FirebaseFirestore.instance.collection('productos').add({
        'sku': sku,
        'nombre': _nombreController.text.trim(),
        'precio': _precioController.text.trim(),
        'marca': _marcaController.text.trim(),
        'imagen': _imagenController.text.trim(),
        'imagenes': imagenes,
        'puntuacion':
            double.tryParse(_puntuacionController.text.trim()) ?? 0.0,
        'comentarios':
            int.tryParse(_comentariosController.text.trim()) ?? 0,
        'disponibles':
            int.tryParse(_disponiblesController.text.trim()) ?? 0,
        'descripcion': _descripcionController.text.trim(),
        'modelo': _modeloController.text.trim(),
        'especificaciones': especificaciones,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

      _limpiarFormulario();

      if (!mounted) return;

      _mostrarMensaje(
        'Producto agregado correctamente.',
        Colors.green,
      );
    } catch (e) {
      _mostrarMensaje(
        'No se pudo guardar el producto.',
        Colors.redAccent,
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  void _limpiarFormulario() {
    _skuController.clear();
    _nombreController.clear();
    _precioController.clear();
    _marcaController.clear();
    _imagenController.clear();
    _imagenesController.clear();
    _disponiblesController.clear();
    _puntuacionController.clear();
    _comentariosController.clear();
    _descripcionController.clear();
    _modeloController.clear();
    _especificacionesController.clear();
  }

  Future<void> _eliminarProducto(String id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Eliminar producto',
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Seguro que deseas eliminar este producto?',
            style: GoogleFonts.nunito(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    await FirebaseFirestore.instance
        .collection('productos')
        .doc(id)
        .delete();

    _mostrarMensaje(
      'Producto eliminado.',
      Colors.green,
    );
  }

  void _mostrarMensaje(String mensaje, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            mensaje,
            style: GoogleFonts.nunito(),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Productos',
          style: GoogleFonts.nunito(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('productos')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: azul,
                    ),
                  );
                }

                final productos = snapshot.data?.docs ?? [];

                if (productos.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay productos todavía.',
                      style: GoogleFonts.nunito(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final doc = productos[index];
                    final data = doc.data();

                    return _ProductoVendedorCard(
                      data: data,
                      onDelete: () {
                        _eliminarProducto(doc.id);
                      },
                    );
                  },
                );
              },
            ),
          ),

          // BOTÓN AGREGAR
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _mostrarFormulario,
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Agregar producto',
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulOscuro,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F8FA),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      15,
                      10,
                      10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Nuevo producto',
                            style: GoogleFonts.nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        5,
                        20,
                        30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _campo(
                              controller: _skuController,
                              label: 'SKU',
                              icon: Icons.qr_code_2,
                              obligatorio: true,
                            ),

                            _campo(
                              controller: _nombreController,
                              label: 'Nombre del producto',
                              icon: Icons.inventory_2_outlined,
                              obligatorio: true,
                            ),

                            _campo(
                              controller: _precioController,
                              label: 'Precio',
                              icon: Icons.attach_money,
                              obligatorio: true,
                              teclado: TextInputType.number,
                            ),

                            _campo(
                              controller: _marcaController,
                              label: 'Marca',
                              icon: Icons.business_outlined,
                            ),

                            _campo(
                              controller: _imagenController,
                              label: 'Imagen principal',
                              icon: Icons.image_outlined,
                              obligatorio: true,
                            ),

                            _campo(
                              controller: _imagenesController,
                              label: 'Imágenes adicionales',
                              icon: Icons.photo_library_outlined,
                              hint:
                                  'URLs separadas por comas',
                            ),

                            _campo(
                              controller: _disponiblesController,
                              label: 'Disponibles',
                              icon: Icons.inventory_outlined,
                              teclado: TextInputType.number,
                            ),

                            _campo(
                              controller: _puntuacionController,
                              label: 'Puntuación',
                              icon: Icons.star_outline,
                              teclado:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),

                            _campo(
                              controller: _comentariosController,
                              label: 'Comentarios',
                              icon: Icons.comment_outlined,
                              teclado: TextInputType.number,
                            ),

                            _campo(
                              controller: _modeloController,
                              label: 'Modelo',
                              icon: Icons.category_outlined,
                            ),

                            _campo(
                              controller: _descripcionController,
                              label: 'Descripción',
                              icon: Icons.description_outlined,
                              maxLines: 4,
                            ),

                            _campo(
                              controller: _especificacionesController,
                              label: 'Especificaciones',
                              icon: Icons.list_alt_outlined,
                              maxLines: 5,
                              hint:
                                  'Una especificación por línea',
                            ),

                            const SizedBox(height: 15),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _guardando
                                    ? null
                                    : () async {
                                        await _guardarProducto();

                                        if (mounted &&
                                            !_guardando) {
                                          Navigator.pop(context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: azulOscuro,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(17),
                                  ),
                                ),
                                child: _guardando
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Guardar producto',
                                        style: GoogleFonts.nunito(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obligatorio = false,
    TextInputType? teclado,
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        maxLines: maxLines,
        validator: obligatorio
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Este campo es obligatorio';
                }
                return null;
              }
            : null,
        style: GoogleFonts.nunito(
          fontSize: 15,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: azulOscuro,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: azul,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductoVendedorCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  const _ProductoVendedorCard({
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imagen = data['imagen']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(15),
            ),
            child: imagen.startsWith('http')
                ? Image.network(
                    imagen,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      );
                    },
                  )
                : Image.asset(
                    imagen,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      );
                    },
                  ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['nombre']?.toString() ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'SKU: ${data['sku'] ?? 'Sin SKU'}',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'MXN ${data['precio'] ?? '0'}',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2971A4),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}