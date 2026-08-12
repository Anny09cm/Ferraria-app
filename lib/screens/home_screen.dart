import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:ferraria/screens/navbar_cliente.dart';
import 'package:ferraria/screens/navbar_vendedor.dart';
import 'package:ferraria/widgets/marca_card.dart';
import 'package:ferraria/widgets/producto_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lista de marcas
    final List<String> marcas = [
      'assets/images/truper.png',
      'assets/images/dewalt.png',
      'assets/images/makita.png',
      'assets/images/urrea.png',
    ];

    final List<Map<String, dynamic>> volverAComprarProductos = [
      {
        'nombre': 'Esmeriladora Angular 4-1/2"',
        'precio': 'MXN 1,250',
        'imagen': 'assets/images/esmeriladora.png',
        'puntuacion': 4.8,
        'comentarios': 24,
      },
      {
        'nombre': 'Juego de Llaves Combinadas',
        'precio': 'MXN 480',
        'imagen': 'assets/images/juego.png',
        'puntuacion': 4.5,
        'comentarios': 12,
      },
      {
        'nombre': 'Rotomartillo Inalámbrico 20V',
        'precio': 'MXN 2,100',
        'imagen': 'assets/images/rotomartillo.png',
        'puntuacion': 4.9,
        'comentarios': 45,
      },
      {
        'nombre': 'Podadora de Pasto 18"',
        'precio': 'MXN 3,450',
        'imagen': 'assets/images/podadora.png',
        'puntuacion': 4.2,
        'comentarios': 8,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavBarCliente(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),

            Text(
              '¡Ofertas del día!',
              style: GoogleFonts.nunito(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 15),

            CarouselSlider(
              items: [
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Caja de Herramientas 19"',
                  precio: 'MXN 399',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Nivel de Gota Torpedo 9"',
                  precio: 'MXN 129',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Juego de Brocas para Concreto',
                  precio: 'MXN 289',
                ),
                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Pistola de Calor 1800W',
                  precio: 'MXN 649',
                ),
              ],
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                enableInfiniteScroll: true,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              'Volver a comprar',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

           
            SizedBox(
              height: 200, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: volverAComprarProductos.length,
                itemBuilder: (context, index) {
                  final prod = volverAComprarProductos[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SizedBox(
                      width: 160,
                      child: ProductoCard(
                        imagen: prod['imagen'],
                        nombre: prod['nombre'],
                        precio: prod['precio'],
                        puntuacion: prod['puntuacion'],
                        comentarios: prod['comentarios'],
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${prod['nombre']} agregado al carrito'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Marcas populares',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),


            SizedBox(
              height: 100, 
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: marcas.length,
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  return MarcaCard(
                    imagenPath: marcas[index],
                    onTap: () {
                      // Filtrar por marca
                    },
                  );
                },
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 30)
          ],
        ),
      ),
    );
  }

  Widget _crearOferta({
    required String imagen,
    required String nombre,
    required String precio,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Image.asset(
                imagen,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OFERTA',
                    style: GoogleFonts.nunito(
                      color: const Color(0xFF73C2FB),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    precio,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: const Color(0xFF73C2FB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}