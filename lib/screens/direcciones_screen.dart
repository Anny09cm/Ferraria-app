import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DireccionesScreen extends StatelessWidget {
  const DireccionesScreen({super.key});

  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static CollectionReference? get _direccionesRef {
    if (_uid == null) return null;
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_uid)
        .collection('direcciones');
  }

  void _mostrarModalAgregarDireccion(BuildContext context) {
    final aliasController = TextEditingController();
    final calleController = TextEditingController();
    final cpController = TextEditingController();
    final ciudadController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nueva Dirección',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2971A4),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aliasController,
                decoration: const InputDecoration(
                  labelText: 'Nombre/Alias (ej. Casa, Trabajo)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: calleController,
                decoration: const InputDecoration(
                  labelText: 'Calle y Número',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'C.P.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: ciudadController,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF73C2FB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (aliasController.text.isNotEmpty &&
                        calleController.text.isNotEmpty) {
                      await _direccionesRef?.add({
                        'alias': aliasController.text,
                        'calle': calleController.text,
                        'cp': cpController.text,
                        'ciudad': ciudadController.text,
                        'esPredeterminada': false,
                        'fechaCreacion': FieldValue.serverTimestamp(),
                      });
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Guardar Dirección',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF73C2FB),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, size: 30),
        ),
        title: Text(
          'Mis Direcciones',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _direccionesRef
            ?.orderBy('fechaCreacion', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF73C2FB)),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'No tienes direcciones guardadas.',
                style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;
              final esPredeterminada = data['esPredeterminada'] ?? false;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: esPredeterminada
                        ? const Color(0xFF73C2FB)
                        : Colors.white,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF73C2FB),
                        size: 32,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['alias'] ?? 'Dirección',
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${data['calle']}, C.P. ${data['cp']}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              data['ciudad'] ?? '',
                              style: GoogleFonts.nunito(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Color(0xFF2971A4)),
                        onPressed: () => _direccionesRef?.doc(docId).delete(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF73C2FB),
        onPressed: () => _mostrarModalAgregarDireccion(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}