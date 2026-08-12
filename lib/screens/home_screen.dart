import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:ferraria/screens/navbar_vendedor.dart';
import 'package:ferraria/screens/navbar_cliente.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 20),


            Text(
              '¡Ofertas del día!',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            CarouselSlider(
              items: [

                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Martillo',
                  precio: '\$199',
                ),

                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Taladro',
                  precio: '\$799',
                ),

                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Juego de herramientas',
                  precio: '\$599',
                ),

                _crearOferta(
                  imagen: 'assets/images/logo.png',
                  nombre: 'Desarmadores',
                  precio: '\$249',
                ),
              ],

              options: CarouselOptions(
                height: 190,

                autoPlay: true,

                autoPlayInterval:
                    const Duration(seconds: 3),

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

            const SizedBox(height: 20),

            const SizedBox(
              height: 100,
            ),

      

            Text(
              'Marcas populares',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(
              height: 100,
            ),
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

          // Imagen
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

          // Información
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    'OFERTA',
                    style: GoogleFonts.orienta(
                      color: const Color(0xFFF4B400),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.orienta(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    precio,
                    style: GoogleFonts.orienta(
                      fontSize: 20,
                      color: const Color(0xFFF4B400),
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