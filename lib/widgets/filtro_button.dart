import 'package:flutter/material.dart';

class FiltroButton extends StatelessWidget {
  final Function(String)? onFiltroSeleccionado;

  const FiltroButton({
    super.key,
    this.onFiltroSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filtrar y Ordenar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ListTile(
                    leading: const Icon(Icons.sort),
                    title: const Text('Ordenar por nombre'),
                    onTap: () {
                      onFiltroSeleccionado?.call('nombre');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.arrow_upward),
                    title: const Text('Precio: menor a mayor'),
                    onTap: () {
                      onFiltroSeleccionado?.call('precio_asc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.arrow_downward),
                    title: const Text('Precio: mayor a menor'),
                    onTap: () {
                      onFiltroSeleccionado?.call('precio_desc');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('Mejor puntuación'),
                    onTap: () {
                      onFiltroSeleccionado?.call('puntuacion');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.branding_watermark_outlined),
                    title: const Text('Filtrar por marca'),
                    onTap: () {
                      onFiltroSeleccionado?.call('marca');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.filter_list),
      style: IconButton.styleFrom(
        foregroundColor: const Color(0xFF73C2FB),
      ),
    );
  }
}