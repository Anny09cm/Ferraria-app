import 'package:flutter/material.dart';

class FiltroButton extends StatelessWidget {
  const FiltroButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const Padding(
              padding: EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    'Filtrar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 20),

                  ListTile(
                    leading: Icon(Icons.sort),
                    title: Text('Ordenar por nombre'),
                  ),

                  ListTile(
                    leading: Icon(Icons.arrow_upward),
                    title: Text('Precio: menor a mayor'),
                  ),

                  ListTile(
                    leading: Icon(Icons.arrow_downward),
                    title: Text('Precio: mayor a menor'),
                  ),

                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Mejor puntuación'),
                  ),
                ],
              ),
            );
          },
        );
      },

      icon: const Icon(
        Icons.filter_list,
      ),

      style: IconButton.styleFrom(
        foregroundColor: Color (0xFF73C2FB),
      ),
    );
  }
}