import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/navbar_vendedor.dart';
import 'package:ferraria/screens/productos_vendedor_screen.dart';
import 'package:ferraria/screens/pedidos_vendedor_screen.dart';

class DashboardVendedorScreen extends StatelessWidget {
  const DashboardVendedorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavBarVendedor(),
      appBar: AppBar(
        backgroundColor: Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dashboard',
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 35),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              '¡Bienvenido!',
              style: GoogleFonts.nunito(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Aquí puedes consultar el resumen de tu tienda.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),


            Text(
              'Resumen de la tienda',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 14),

            _crearTarjeta(
              icono: Icons.attach_money_rounded,
              titulo: 'Ventas del día',
              valor: '\$8,450',
            ),

            const SizedBox(height: 13),

            _crearTarjeta(
              icono: Icons.shopping_bag_outlined,
              titulo: 'Pedidos pendientes',
              valor: '12',
            ),

            const SizedBox(height: 13),

            _crearTarjeta(
              icono: Icons.inventory_2_outlined,
              titulo: 'Productos disponibles',
              valor: '156',
            ),

            const SizedBox(height: 13),

            _crearTarjeta(
              icono: Icons.people_outline_rounded,
              titulo: 'Clientes',
              valor: '84',
            ),

            const SizedBox(height: 30),

            Text(
              'Acciones rápidas',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _botonAccion(
                    icono: Icons.add_box_outlined,
                    texto: 'Agregar producto',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductosVendedorScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _botonAccion(
                    icono: Icons.receipt_long_outlined,
                    texto: 'Ver pedidos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PedidosVendedorScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              'Actividad reciente',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),

            const SizedBox(height: 14),

            _crearActividad(
              icono: Icons.shopping_cart_outlined,
              titulo: 'Nuevo pedido recibido',
              subtitulo: 'Pedido pendiente de revisión',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PedidosVendedorScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _crearActividad(
              icono: Icons.check_circle_outline_rounded,
              titulo: 'Gestiona tus pedidos',
              subtitulo: 'Consulta el estado de tus ventas',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PedidosVendedorScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _crearActividad(
              icono: Icons.inventory_2_outlined,
              titulo: 'Administra tus productos',
              subtitulo: 'Agrega y modifica productos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductosVendedorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearTarjeta({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(77, 0, 0, 0),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],

        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),

      child: Row(
        children: [

          // ICONO
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: Color.fromARGB(103, 115, 194, 251),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(
              icono,
              color: Color(0xFF2971A4),
              size: 29,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  titulo,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  valor,
                  style: GoogleFonts.nunito(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey,
            size: 25,
          ),
        ],
      ),
    );
  }

  Widget _botonAccion({
    required IconData icono,
    required String texto,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(20),

        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 18,
          ),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(20),

            border: Border.all(
              color: Color.fromARGB(100, 115, 194, 251),
            ),

            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(97, 0, 0, 0),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            children: [

              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 115, 194, 251),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(
                  icono,
                  color:Color(0xFF2971A4),
                  size: 28,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                texto,
                textAlign: TextAlign.center,

                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearActividad({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Ink(
          width: double.infinity,

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: Colors.grey.shade100,
            ),

            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(95, 0, 0, 0),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [

              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 115, 194, 251),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  icono,
                  color: Color(0xFF2971A4),
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}