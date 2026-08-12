import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 175, 180, 165),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.nunito(
              color: Colors.grey,
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF73C2FB),
              size: 20,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}