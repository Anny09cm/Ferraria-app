import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ferraria/services/cart_favorites_service.dart';
import 'package:ferraria/screens/checkout_screen.dart';
import 'package:ferraria/screens/producto_especifico_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final double metaEnvioGratis = 1000.00;
  final double costoEnvioFijo = 80.00;

  double _parsePrecio(dynamic valor) {
    if (valor == null) return 0.0;
    if (valor is num) return valor.toDouble();
    String texto = valor.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(texto) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        elevation: 0,
        title: Text(
          'Mi carrito',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
            onPressed: () {
              CartFavoritesService.vaciarCarrito();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CartFavoritesService.obtenerCarritoStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF73C2FB)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Tu carrito está vacío',
                style: GoogleFonts.nunito(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          double subtotal = 0.0;
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final precio = _parsePrecio(data['precio']);
            final cantidad = (data['cantidad'] ?? 1) as int;
            subtotal += precio * cantidad;
          }

          double envio = subtotal >= metaEnvioGratis ? 0.0 : costoEnvioFijo;
          double total = subtotal + envio;
          double faltaParaEnvioGratis =
              subtotal >= metaEnvioGratis ? 0.0 : metaEnvioGratis - subtotal;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildBannerEnvioGratis(subtotal, faltaParaEnvioGratis),
                const SizedBox(height: 20),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(122, 0, 0, 0),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final item = doc.data() as Map<String, dynamic>;
                        return _buildItemCarrito(doc.id, item);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                _buildResumenPago(subtotal, envio, total),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2971A4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(totalPagar: total),
                        ),
                      );
                    },
                    child: Text(
                      'Finalizar compra',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerEnvioGratis(double subtotal, double faltaParaEnvioGratis) {
    double porcentaje = (subtotal / metaEnvioGratis).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(57, 115, 194, 251),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF73C2FB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(192, 41, 113, 164),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  faltaParaEnvioGratis > 0
                      ? '¡Falta MXN ${faltaParaEnvioGratis.toStringAsFixed(2)} para envío gratis!'
                      : '¡Felicidades! Tienes envío gratis',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: porcentaje,
              minHeight: 8,
              backgroundColor: const Color(0xFFE0E0E0),
              color: const Color.fromARGB(192, 41, 113, 164),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'MXN ${subtotal.toStringAsFixed(2)} / MXN ${metaEnvioGratis.toStringAsFixed(2)}',
              style: GoogleFonts.nunito(
                color: const Color(0xFF2971A4),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ITEM CON NAVEGACIÓN A DETALLES DEL PRODUCTO
  Widget _buildItemCarrito(String docId, Map<String, dynamic> item) {
    final cantidad = (item['cantidad'] ?? 1) as int;
    final precioNum = _parsePrecio(item['precio']);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // NAVEGACIÓN A ESPECIFICACIONES AL TOCAR LA IMAGEN O EL TEXTO
          GestureDetector(
            onTap: () async {
              // Buscar información detallada del producto en Firestore
              final docQuery = await FirebaseFirestore.instance
                  .collection('productos')
                  .where('nombre', isEqualTo: item['nombre'])
                  .limit(1)
                  .get();

              if (docQuery.docs.isNotEmpty && context.mounted) {
                final productoData = docQuery.docs.first.data();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductoEspecificoScreen(
                      nombre: productoData["nombre"]?.toString() ?? '',
                      precio: productoData["precio"]?.toString() ?? '',
                      marca: productoData["marca"]?.toString() ?? 'Generico',
                      sku: productoData["sku"]?.toString() ?? '',
                      imagen: productoData["imagen"]?.toString() ?? '',
                      imagenes: (productoData["imagenes"] as List<dynamic>?)
                          ?.cast<String>(),
                      puntuacion: double.tryParse(
                        productoData["puntuacion"]?.toString() ?? '0.0',
                      ),
                      comentarios: int.tryParse(
                        productoData["comentarios"]?.toString() ?? '0',
                      ),
                      descripcion: productoData["descripcion"]?.toString(),
                      modelo: productoData["modelo"]?.toString(),
                      especificaciones: (productoData["especificaciones"]
                              as List<dynamic>?)
                          ?.cast<String>(),
                    ),
                  ),
                );
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item['imagen'] ?? '',
                width: 65,
                height: 65,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final docQuery = await FirebaseFirestore.instance
                    .collection('productos')
                    .where('nombre', isEqualTo: item['nombre'])
                    .limit(1)
                    .get();

                if (docQuery.docs.isNotEmpty && context.mounted) {
                  final productoData = docQuery.docs.first.data();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductoEspecificoScreen(
                        nombre: productoData["nombre"]?.toString() ?? '',
                        precio: productoData["precio"]?.toString() ?? '',
                        marca: productoData["marca"]?.toString() ?? 'Generico',
                        imagen: productoData["imagen"]?.toString() ?? '',
                        imagenes: (productoData["imagenes"] as List<dynamic>?)
                            ?.cast<String>(),
                        puntuacion: double.tryParse(
                          productoData["puntuacion"]?.toString() ?? '0.0',
                        ),
                        comentarios: int.tryParse(
                          productoData["comentarios"]?.toString() ?? '0',
                        ),
                        descripcion: productoData["descripcion"]?.toString(),
                        modelo: productoData["modelo"]?.toString(),
                        especificaciones: (productoData["especificaciones"]
                                as List<dynamic>?)
                            ?.cast<String>(),
                      ),
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nombre'] ?? '',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'MXN ${precioNum.toStringAsFixed(2)}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            CartFavoritesService.actualizarCantidad(
                              docId,
                              cantidad - 1,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Text(
                              '-',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$cantidad',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            CartFavoritesService.actualizarCantidad(
                              docId,
                              cantidad + 1,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF2971A4)),
            onPressed: () {
              CartFavoritesService.eliminarDelCarrito(docId);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResumenPago(double subtotal, double envio, double total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[700])),
            Text('MXN ${subtotal.toStringAsFixed(2)}',
                style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Envío', style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[700])),
            Text(
              envio == 0 ? 'Gratis' : 'MXN ${envio.toStringAsFixed(2)}',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: envio == 0 ? const Color(0xFF2971A4) : Colors.black,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Color(0xFFEEEEEE)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              'MXN ${total.toStringAsFixed(2)}',
              style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}