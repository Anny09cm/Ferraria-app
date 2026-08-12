import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/navbar_vendedor.dart';

class DashboardVendedorScreen extends StatelessWidget {
  const DashboardVendedorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      // Menú lateral
      drawer: const NavBarVendedor(),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4B400),
        foregroundColor: Colors.white,
        elevation: 4,

        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Bienvenida
            Text(
              'Bienvenido, vendedor',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Aquí puedes consultar el resumen de tu tienda.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            // Ventas
            _crearTarjeta(
              icono: Icons.attach_money,
              titulo: 'Ventas del día',
              valor: '\$8,450',
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            // Pedidos
            _crearTarjeta(
              icono: Icons.shopping_bag,
              titulo: 'Pedidos pendientes',
              valor: '12',
              color: Colors.orange,
            ),

            const SizedBox(height: 15),

            // Productos
            _crearTarjeta(
              icono: Icons.inventory_2,
              titulo: 'Productos disponibles',
              valor: '156',
              color: Colors.blue,
            ),

            const SizedBox(height: 15),

            // Clientes
            _crearTarjeta(
              icono: Icons.people,
              titulo: 'Clientes',
              valor: '84',
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            Text(
              'Acciones rápidas',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: _botonAccion(
                    icono: Icons.add_box,
                    texto: 'Agregar producto',
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _botonAccion(
                    icono: Icons.receipt_long,
                    texto: 'Ver pedidos',
                    onTap: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              'Actividad reciente',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF4B400),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  'Nuevo pedido recibido',
                ),

                subtitle: const Text(
                  'Pedido #00125',
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),

                title: const Text(
                  'Pedido completado',
                ),

                subtitle: const Text(
                  'Pedido #00120',
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjetas de información
  Widget _crearTarjeta({
    required IconData icono,
    required String titulo,
    required String valor,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Row(
          children: [

            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.15),

              child: Icon(
                icono,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  valor,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Botones de acciones rápidas
  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(0, 2),
              color: Colors.black12,
            ),
          ],
        ),

        child: Column(
          children: [

            const SizedBox(height: 5),

            Icon(
              icono,
              color: const Color(0xFFF4B400),
              size: 32,
            ),

            const SizedBox(height: 8),

            Text(
              texto,
              textAlign: TextAlign.center,

              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}