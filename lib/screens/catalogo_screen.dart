import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/categoria_screen.dart';
import 'package:ferraria/widgets/categoria_card.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<Map<String, String>> categorias = [
    {
      "categoria": "Herramientas",
      "imagen": "assets/images/herramientas.png"
    },
    {
      "categoria": "Materiales",
      "imagen": "assets/images/construccion.png"
    },
    {
      "categoria": "Electricidad",
      "imagen": "assets/images/electricidad.png"
    },
    {
      "categoria": "Plomeria",
      "imagen": "assets/images/plomeria.png"
    },
    {
      "categoria": "Pinturas",
      "imagen": "assets/images/pintura.png"
    },
    {
      "categoria": "Tornilleria",
      "imagen": "assets/images/tornilleria.png"
    },
    {
      "categoria": "Seguridad",
      "imagen": "assets/images/seguridad.png"
    },
    {
      "categoria": "Jardineria",
      "imagen": "assets/images/jardineria.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,

      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        elevation: 4,
        automaticallyImplyLeading: false,
        centerTitle: true,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),

        title: Text(
          'Catálogo',
          style: GoogleFonts.nunito(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 90), // 👈 Padding inferior para no ser tapado por el navbar
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            mainAxisExtent: 190,
          ),

          itemCount: categorias.length,

          itemBuilder: (context, index) {
            final categoriaNombre =
                categorias[index]["categoria"] ?? '';

            final categoriaImagen =
                categorias[index]["imagen"] ?? '';

            return GestureDetector(
              onTap: () {
                List<Map<String, String>> listaDeProductos = [];

                if (categoriaNombre == "Herramientas") {
                  listaDeProductos = [
                    {
                      "nombre": "Martillos",
                      "imagen": "assets/images/martillo.png",
                    },
                    {
                      "nombre": "Destornilladores",
                      "imagen": "assets/images/destornillador.png",
                    },
                    {
                      "nombre": "Alicates",
                      "imagen": "assets/images/alicate.png",
                    },
                    {
                      "nombre": "Taladros",
                      "imagen": "assets/images/taladro.png",
                    },
                    {
                      "nombre": "Llaves",
                      "imagen": "assets/images/juego.png",
                    },
                  ];
                } else if (categoriaNombre == "Electricidad") {
                  listaDeProductos = [
                    {
                      "nombre": "Cables",
                      "imagen": "assets/images/cables.png",
                    },
                    {
                      "nombre": "Interruptores",
                      "imagen": "assets/images/interruptor.png",
                    },
                  ];
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriaScreen(
                      categoria: categoriaNombre,
                      productos: listaDeProductos,
                    ),
                  ),
                );
              },

              child: CategoriaCard(
                categoria: categoriaNombre,
                imagen: categoriaImagen,
              ),
            );
          },
        ),
      ),
    );
  }
}