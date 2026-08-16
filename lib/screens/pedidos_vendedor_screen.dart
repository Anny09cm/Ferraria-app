import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PedidosVendedorScreen extends StatelessWidget {
  const PedidosVendedorScreen({super.key});

  static const Color azulClaro = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);
  static const Color fondo = Color(0xFFF5F8FA);
  static const Color texto = Color(0xFF1F2937);
  static const Color textoSecundario = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: azulClaro,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pedidos',
          style: GoogleFonts.nunito(
            fontSize: 21,
            fontWeight: FontWeight.w800,
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
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: azulClaro,
              ),
            );
          }

          if (snapshot.hasError) {
            return _estadoVacio(
              icono: Icons.error_outline,
              titulo: 'No se pudieron cargar los pedidos',
              subtitulo: 'Revisa la conexión con Firebase.',
            );
          }

          final pedidos = snapshot.data?.docs ?? [];

          if (pedidos.isEmpty) {
            return _estadoVacio(
              icono: Icons.receipt_long_outlined,
              titulo: 'No hay pedidos',
              subtitulo: 'Cuando un cliente realice una compra aparecerá aquí.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final doc = pedidos[index];
              return _PedidoCard(
                pedidoId: doc.id,
                data: doc.data(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _estadoVacio({
    required IconData icono,
    required String titulo,
    required String subtitulo,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: azulClaro.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                color: azulOscuro,
                size: 45,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: texto,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// CARD DEL PEDIDO
// =============================================================

class _PedidoCard extends StatelessWidget {
  final String pedidoId;
  final Map<String, dynamic> data;

  const _PedidoCard({
    required this.pedidoId,
    required this.data,
  });

  static const Color azulClaro = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);
  static const Color texto = Color(0xFF1F2937);
  static const Color textoSecundario = Color(0xFF6B7280);

  String _estado() {
    return data['estado']?.toString() ?? 'Pendiente';
  }

  double _total() {
    final valor = data['total'];
    if (valor is num) {
      return valor.toDouble();
    }
    return double.tryParse(
          valor?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '',
        ) ??
        0;
  }

  String _fecha() {
    final timestamp = data['fecha'];
    if (timestamp is Timestamp) {
      final fecha = timestamp.toDate();
      return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    }
    return 'Fecha no disponible';
  }

  int _cantidadProductos() {
    final productos = data['productos'];
    if (productos is! List) {
      return 0;
    }
    int cantidad = 0;
    for (final producto in productos) {
      if (producto is Map) {
        final valor = producto['cantidad'];
        if (valor is num) {
          cantidad += valor.toInt();
        } else {
          cantidad++;
        }
      }
    }
    return cantidad;
  }

  @override
  Widget build(BuildContext context) {
    final estado = _estado();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          _mostrarDetallePedido(
            context,
            pedidoId,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------
              // CABECERA
              // -------------------------------------------------
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: azulClaro.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: azulOscuro,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${pedidoId.substring(0, pedidoId.length > 8 ? 8 : pedidoId.length)}',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: texto,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _fecha(),
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: textoSecundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _EstadoChip(
                    estado: estado,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(
                height: 1,
              ),
              const SizedBox(height: 14),

              // -------------------------------------------------
              // INFORMACIÓN
              // -------------------------------------------------
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 20,
                    color: azulOscuro,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_cantidadProductos()} productos',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: textoSecundario,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'MXN ${_total().toStringAsFixed(2)}',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: azulOscuro,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // -------------------------------------------------
              // BOTÓN ESTADO
              // -------------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 43,
                child: OutlinedButton(
                  onPressed: () {
                    _mostrarCambiarEstado(
                      context,
                      pedidoId,
                      estado,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: azulOscuro,
                    side: const BorderSide(
                      color: azulClaro,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(
                    'Actualizar estado',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // DETALLE
  // ===========================================================

  void _mostrarDetallePedido(
    BuildContext context,
    String pedidoId,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _DetallePedido(
          pedidoId: pedidoId,
          data: data,
        );
      },
    );
  }

  // ===========================================================
  // CAMBIAR ESTADO
  // ===========================================================

  void _mostrarCambiarEstado(
    BuildContext context,
    String pedidoId,
    String estadoActual,
  ) {
    final estados = [
      'Pendiente',
      'Confirmado',
      'Enviado',
      'Entregado',
      'Cancelado',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Estado del pedido',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 15),
              ...estados.map(
                (estado) {
                  final seleccionado = estado == estadoActual;
                  return ListTile(
                    leading: Icon(
                      seleccionado ? Icons.check_circle : Icons.circle_outlined,
                      color: seleccionado ? azulOscuro : Colors.grey,
                    ),
                    title: Text(
                      estado,
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await FirebaseFirestore.instance
                          .collection('pedidos')
                          .doc(pedidoId)
                          .update({'estado': estado});
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================
// CHIP ESTADO
// =============================================================

class _EstadoChip extends StatelessWidget {
  final String estado;

  const _EstadoChip({
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (estado) {
      case 'Confirmado':
        color = Colors.blue;
        break;
      case 'Enviado':
        color = Colors.orange;
        break;
      case 'Entregado':
        color = Colors.green;
        break;
      case 'Cancelado':
        color = Colors.red;
        break;
      default:
        color = const Color(0xFF2971A4);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

// =============================================================
// DETALLE DEL PEDIDO
// =============================================================

class _DetallePedido extends StatelessWidget {
  final String pedidoId;
  final Map<String, dynamic> data;

  const _DetallePedido({
    required this.pedidoId,
    required this.data,
  });

  static const Color azulClaro = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);

  @override
  Widget build(BuildContext context) {
    final productos = data['productos'] is List ? List.from(data['productos']) : [];
    final direccion = data['direccion'] is Map ? Map<String, dynamic>.from(data['direccion']) : {};

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F8FA),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pedido #$pedidoId',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              children: [
                Text(
                  'Productos',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ...productos.map(
                  (producto) {
                    if (producto is! Map) {
                      return const SizedBox();
                    }

                    final nombre = producto['nombre']?.toString() ?? 'Producto';
                    final cantidad = producto['cantidad'] ?? 1;
                    final precio = producto['precio']?.toString() ?? '0';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: azulClaro.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: azulOscuro,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombre,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Cantidad: $cantidad',
                                  style: GoogleFonts.nunito(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'MXN $precio',
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w800,
                              color: azulOscuro,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Dirección de entrega',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${direccion['calle'] ?? ''}\nCP ${direccion['cp'] ?? ''}',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}