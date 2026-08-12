import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {

  List<Map<String, dynamic>> itemsCarrito = [
    {
      'id': '1',
      'nombre': 'Taladro eléctrico 1/2"\n800W',
      'precio': 1250.00,
      'cantidad': 1,
      'imagen': 'assets/images/taladro.png', 
    },
    {
      'id': '2',
      'nombre': 'Martillo de uña 16 oz\nmango de fibra',
      'precio': 159.00,
      'cantidad': 1,
      'imagen': 'assets/images/martillo.png',
    },
    {
      'id': '3',
      'nombre': 'Caja de tornillos\npara madera #8 x 1"',
      'precio': 80.00,
      'cantidad': 1,
      'imagen': 'assets/images/tornilleria.png',
    },
  ];

  final double metaEnvioGratis = 1000.00;
  final double costoEnvioFijo = 80.00;

  // Cálculos dinámicos
  double get subtotal => itemsCarrito.fold(
        0,
        (sum, item) => sum + (item['precio'] * item['cantidad']),
      );

  double get envio => subtotal >= metaEnvioGratis ? 0.0 : costoEnvioFijo;

  double get total => subtotal + envio;

  double get faltaParaEnvioGratis =>
      subtotal >= metaEnvioGratis ? 0.0 : metaEnvioGratis - subtotal;

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
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
            onPressed: () {
              setState(() {
                itemsCarrito.clear();
              });
            },
          ),
        ],
      ),
      body: itemsCarrito.isEmpty
          ? Center(
              child: Text(
                'Tu carrito está vacío',
                style: GoogleFonts.nunito(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  _buildBannerEnvioGratis(),

                  const SizedBox(height: 20),

                  // 2. TARJETA CONTENEDORA DE PRODUCTOS (CORREGIDA)
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
                      borderRadius: BorderRadius.circular(16), // Recorta los bordes exactos
                      child: ListView.separated(
                        padding: EdgeInsets.zero, // 👈 Elimina el espacio blanco inferior y superior
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: itemsCarrito.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                        itemBuilder: (context, index) {
                          final item = itemsCarrito[index];
                          return _buildItemCarrito(item, index);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _buildResumenPago(),

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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Procesando compra por MXN ${total.toStringAsFixed(2)}',
                              style: GoogleFonts.nunito(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Finalizar compra',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 80), // Espacio para el navbar
                ],
              ),
            ),
    );
  }

  // WIDGET BANNER ENVÍO GRATIS
  Widget _buildBannerEnvioGratis() {
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
          // BARRA DE PROGRESO
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

  // WIDGET ITEM INDIVIDUAL DE PRODUCTO
  Widget _buildItemCarrito(Map<String, dynamic> item, int index) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item['imagen'],
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Detalles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nombre'],
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'MXN ${item['precio'].toStringAsFixed(2)}',
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
                          setState(() {
                            if (item['cantidad'] > 1) {
                              item['cantidad']--;
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${item['cantidad']}',
                          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            item['cantidad']++;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botón eliminar
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF2971A4)),
            onPressed: () {
              setState(() {
                itemsCarrito.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  // WIDGET RESUMEN DE PRECIOS
  Widget _buildResumenPago() {
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