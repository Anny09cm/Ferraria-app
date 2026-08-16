import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ferraria/screens/categoria_screen.dart';
import 'package:ferraria/screens/lista_productos_screen.dart';
import 'package:ferraria/widgets/categoria_card.dart';

class CatalogoScreen extends StatefulWidget {
  final VoidCallback? onIrAlCarrito;
  final bool esVendedor;

  const CatalogoScreen({
    super.key,
    this.onIrAlCarrito,
    this.esVendedor = false,
  });

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<Map<String, String>> categorias = [
    {
      "categoria": "Herramientas",
      "imagen": "assets/images/herramientas.png",
    },
    {
      "categoria": "Electricidad",
      "imagen": "assets/images/electricidad.png",
    },
    {
      "categoria": "Plomeria",
      "imagen": "assets/images/plomeria.png",
    },
    {
      "categoria": "Materiales",
      "imagen": "assets/images/construccion.png",
    },
    {
      "categoria": "Pinturas",
      "imagen": "assets/images/pintura.png",
    },
    {
      "categoria": "Tornilleria",
      "imagen": "assets/images/tornilleria.png",
    },
    {
      "categoria": "Seguridad",
      "imagen": "assets/images/seguridad.png",
    },
    {
      "categoria": "Jardineria",
      "imagen": "assets/images/jardineria.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          widget.esVendedor
              ? 'Catálogo de productos'
              : 'Catálogo',
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 90,
        ),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
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
                if (categoriaNombre == "Herramientas" ||
                    categoriaNombre == "Electricidad" ||
                    categoriaNombre == "Plomeria") {
                  List<Map<String, String>> subcategorias = [];

                  if (categoriaNombre == "Herramientas") {
                    subcategorias = [
                      {
                        "nombre": "Martillos",
                        "imagen": "assets/images/martillo.png",
                      },
                      {
                        "nombre": "Destornilladores",
                        "imagen":
                            "assets/images/destornillador.png",
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
                        "imagen": "assets/images/llaves.png",
                      },
                    ];
                  } else if (categoriaNombre == "Electricidad") {
                    subcategorias = [
                      {
                        "nombre": "Cables",
                        "imagen": "assets/images/cables.png",
                      },
                      {
                        "nombre": "Interruptores",
                        "imagen":
                            "assets/images/interruptores.png",
                      },
                      {
                        "nombre": "Iluminación",
                        "imagen": "assets/images/focos.png",
                      },
                    ];
                  } else if (categoriaNombre == "Plomeria") {
                    subcategorias = [
                      {
                        "nombre": "Tubos PVC",
                        "imagen":
                            "assets/images/tubospvc.png",
                      },
                      {
                        "nombre": "Llaves y Grifos",
                        "imagen":
                            "assets/images/grifos.png",
                      },
                    ];
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriaScreen(
                        categoria: categoriaNombre,
                        productos: subcategorias,
                        esVendedor: widget.esVendedor,
                        onIrAlCarrito:
                            widget.onIrAlCarrito,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ListaProductosScreen(
                        tipo: categoriaNombre,
                        esVendedor: widget.esVendedor,
                        onIrAlCarrito:
                            widget.onIrAlCarrito,
                      ),
                    ),
                  );
                }
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