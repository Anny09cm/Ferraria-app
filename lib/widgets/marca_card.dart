import 'package:flutter/material.dart';

class MarcaCard extends StatelessWidget {
  final String imagenPath;
  final VoidCallback? onTap;

  const MarcaCard({
    super.key,
    required this.imagenPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140, 
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            imagenPath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, // Cubre todo el cuadro
            errorBuilder: (context, error, stackTrace) {
              // Si aún no tienes la foto en assets, muestra esto temporalmente
              return Container(
                color: Colors.grey[100],
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.store, color: Color(0xFF73C2FB), size: 30),
                    const SizedBox(height: 4),
                    Text(
                      imagenPath.split('/').last.replaceAll('.png', '').toUpperCase(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}