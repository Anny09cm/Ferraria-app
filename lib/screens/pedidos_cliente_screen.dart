import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PedidosClienteScreen extends StatelessWidget {
  const PedidosClienteScreen({super.key});

  static const Color azul = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);

  String _formatearFecha(Timestamp? timestamp) {
    if (timestamp == null) return 'Fecha no disponible';
    final fecha = timestamp.toDate();
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  Color _colorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'entregado':
        return Colors.green;
      case 'enviado':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      case 'procesando':
        return Colors.orange;
      default:
        return azulOscuro;
    }
  }

  IconData _iconoEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'entregado':
        return Icons.check_circle_outline;
      case 'enviado':
        return Icons.local_shipping_outlined;
      case 'cancelado':
        return Icons.cancel_outlined;
      case 'procesando':
        return Icons.inventory_2_outlined;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis pedidos'),
          backgroundColor: azul,
        ),
        body: const Center(
          child: Text('Debes iniciar sesión para ver tus pedidos.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Mis pedidos',
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .where('usuarioId', isEqualTo: usuario.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: azul,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No se pudieron cargar tus pedidos.',
                style: GoogleFonts.nunito(
                  color: Colors.grey[700],
                ),
              ),
            );
          }

          final pedidos = snapshot.data?.docs ?? [];

          if (pedidos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(56, 115, 194, 251),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 50,
                        color: azulOscuro,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Aún no tienes pedidos',
                      style: GoogleFonts.nunito(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cuando realices una compra aparecerá aquí.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Ordenar localmente para evitar necesitar índice de Firestore.
          final lista = [...pedidos];

          lista.sort((a, b) {
            final fechaA = a.data()['fecha'] as Timestamp?;
            final fechaB = b.data()['fecha'] as Timestamp?;

            if (fechaA == null) return 1;
            if (fechaB == null) return -1;

            return fechaB.compareTo(fechaA);
          });

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final pedido = lista[index].data();

              return _PedidoCard(
                pedidoId: lista[index].id,
                pedido: pedido,
                formatearFecha: _formatearFecha,
                colorEstado: _colorEstado,
                iconoEstado: _iconoEstado,
              );
            },
          );
        },
      ),
    );
  }
}

class _PedidoCard extends StatelessWidget {
  final String pedidoId;
  final Map<String, dynamic> pedido;

  final String Function(Timestamp?) formatearFecha;
  final Color Function(String) colorEstado;
  final IconData Function(String) iconoEstado;

  const _PedidoCard({
    required this.pedidoId,
    required this.pedido,
    required this.formatearFecha,
    required this.colorEstado,
    required this.iconoEstado,
  });

  @override
  Widget build(BuildContext context) {
    final estado = pedido['estado']?.toString() ?? 'Pendiente';
    final total = (pedido['total'] as num?)?.toDouble() ?? 0.0;
    final productos = (pedido['productos'] as List<dynamic>?) ?? [];
    final fecha = pedido['fecha'] as Timestamp?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF73C2FB).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xFF2971A4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${pedidoId.substring(0, 6).toUpperCase()}',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        formatearFecha(fecha),
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: colorEstado(estado).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconoEstado(estado),
                        size: 15,
                        color: colorEstado(estado),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        estado,
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorEstado(estado),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 12),
            ...productos.take(3).map((producto) {
              final data = producto as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    _ImagenProducto(
                      imagen: data['imagen']?.toString() ?? '',
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['nombre']?.toString() ?? 'Producto',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Cantidad: ${data['cantidad'] ?? 1}',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'MXN ${_precio(data['precio']).toStringAsFixed(2)}',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (productos.length > 3)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '+ ${productos.length - 3} producto(s) más',
                  style: GoogleFonts.nunito(
                    color: const Color(0xFF2971A4),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  'MXN ${total.toStringAsFixed(2)}',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2971A4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static double _precio(dynamic valor) {
    if (valor == null) return 0;
    if (valor is num) {
      return valor.toDouble();
    }
    final texto = valor.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(texto) ?? 0;
  }
}

class _ImagenProducto extends StatelessWidget {
  final String imagen;

  const _ImagenProducto({
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (imagen.isEmpty) {
      return const Icon(
        Icons.image_outlined,
        color: Colors.grey,
      );
    }

    if (imagen.startsWith('http')) {
      return Image.network(
        imagen,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
          );
        },
      );
    }

    return Image.asset(
      imagen,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) {
        return const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
        );
      },
    );
  }
}