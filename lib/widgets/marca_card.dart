import 'package:flutter/material.dart';

class MarcaCard extends StatelessWidget {
  const MarcaCard ({super.key,});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: const Color.fromARGB(255, 175, 180, 165),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(),
    );
  }
}