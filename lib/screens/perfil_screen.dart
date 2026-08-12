import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  // Cambia a true para probar cómo se ve la vista de vendedor
  bool isVendedor = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo gris muy claro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Perfil',
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // 1. HEADER DE USUARIO
            // =========================
            _buildProfileHeader(),

            const SizedBox(height: 25),

            // Switch de prueba (para alternar entre Cliente y Vendedor)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modo Vendedor',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Switch(
                  value: isVendedor,
                  activeThumbColor: const Color(0xFF73C2FB),
                  onChanged: (val) {
                    setState(() {
                      isVendedor = val;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            // =========================
            // 2. SECCIONES SEGÚN EL ROL
            // =========================
            if (isVendedor) ...[
              _buildSectionTitle('Gestión de Ferretería'),
              _buildGroupContainer([
                _buildOptionTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'Mis Productos e Inventario',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Pedidos por Entregar',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.bar_chart_outlined,
                  title: 'Ventas y Reportes',
                  onTap: () {},
                ),
              ]),
            ] else ...[
              _buildSectionTitle('Mis Compras'),
              _buildGroupContainer([
                _buildOptionTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Historial de Pedidos',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.location_on_outlined,
                  title: 'Mis Direcciones de Envío',
                  onTap: () {},
                ),
                _buildOptionTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'Mis Facturas',
                  onTap: () {},
                ),
              ]),
            ],

            const SizedBox(height: 20),

            // =========================
            // 3. CONFIGURACIÓN GENERAL
            // =========================
            _buildSectionTitle('Cuenta y Preferencias'),
            _buildGroupContainer([
              _buildOptionTile(
                icon: Icons.person_outline,
                title: 'Editar Mi Perfil',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notificaciones',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.lock_outline,
                title: 'Seguridad y Contraseña',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 20),

            // =========================
            // 4. SOPORTE Y CERRAR SESIÓN
            // =========================
            _buildSectionTitle('Soporte'),
            _buildGroupContainer([
              _buildOptionTile(
                icon: Icons.help_outline,
                title: 'Centro de Ayuda',
                onTap: () {},
              ),
              _buildOptionTile(
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                showChevron: false,
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // WIDGET: Header con foto, nombre y correo
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(118, 0, 0, 0),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage('assets/images/martillo.png'), // Tu imagen o foto de usuario
            backgroundColor: Color(0xFFF4B400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dara Anaid',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'dara.anaid@gmail.com',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Título de cada sección en gris
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
      ),
    );
  }

  // WIDGET: Contenedor agrupador blanco redondeado
  Widget _buildGroupContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(104, 0, 0, 0),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // WIDGET: Cada fila u opción dentro del grupo
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    Color textColor = Colors.black87,
    bool showChevron = true,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
          : null,
    );
  }
}