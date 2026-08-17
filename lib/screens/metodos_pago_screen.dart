import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MetodosPagoScreen extends StatelessWidget {
  const MetodosPagoScreen({super.key});

  static const Color azul = Color(0xFF73C2FB);
  static const Color azulOscuro = Color(0xFF2971A4);
  static const Color fondo = Color(0xFFF6F8FB);

  static String? get _uid =>
      FirebaseAuth.instance.currentUser?.uid;

  static CollectionReference<Map<String, dynamic>>?
      get _metodosPagoRef {
    final uid = _uid;

    if (uid == null) return null;

    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('metodos_pago');
  }


  void _mostrarMensaje(
    BuildContext context,
    String mensaje, {
    bool error = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            mensaje,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
              error ? azulOscuro : azulOscuro,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  void _mostrarModalAgregarTarjeta(
    BuildContext context,
  ) {
    final titularController = TextEditingController();
    final numeroController = TextEditingController();
    final expiracionController = TextEditingController();

    String tipoTarjeta = 'Visa';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 22,
                  right: 22,
                  top: 12,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                          22,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: azul.withOpacity(0.15),
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.credit_card_rounded,
                              color: azulOscuro,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Agregar tarjeta',
                                  style: GoogleFonts.nunito(
                                    fontSize: 21,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: azulOscuro,
                                  ),
                                ),
                                Text(
                                  'Guarda tu tarjeta para futuros pagos',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF73C2FB),
                              Color(0xFF2971A4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  azul.withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.contactless_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                Text(
                                  tipoTarjeta,
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Text(
                              '••••  ••••  ••••  ${numeroController.text.length >= 4 ? numeroController.text.substring(numeroController.text.length - 4) : '0000'}',
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              titularController.text.isEmpty
                                  ? 'NOMBRE DEL TITULAR'
                                  : titularController.text
                                      .toUpperCase(),
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      Text(
                        'Nombre del titular',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: titularController,
                        textCapitalization:
                            TextCapitalization.words,
                        onChanged: (_) {
                          setModalState(() {});
                        },
                        decoration: _inputDecoration(
                          'Ej. Juan Pérez',
                          Icons.person_outline_rounded,
                        ),
                      ),

                      const SizedBox(height: 16),


                      Text(
                        'Número de tarjeta',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: numeroController,
                        keyboardType:
                            TextInputType.number,
                        maxLength: 16,
                        onChanged: (valor) {
                          setModalState(() {
                            if (valor.startsWith('4')) {
                              tipoTarjeta = 'Visa';
                            } else if (valor.startsWith('5')) {
                              tipoTarjeta = 'Mastercard';
                            } else {
                              tipoTarjeta = 'Tarjeta';
                            }
                          });
                        },
                        decoration: _inputDecoration(
                          '0000 0000 0000 0000',
                          Icons.credit_card_rounded,
                        ).copyWith(
                          counterText: '',
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Fecha de vencimiento',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: expiracionController,
                        keyboardType:
                            TextInputType.datetime,
                        maxLength: 5,
                        decoration: _inputDecoration(
                          'MM/AA',
                          Icons.calendar_month_outlined,
                        ).copyWith(
                          counterText: '',
                        ),
                      ),

                      const SizedBox(height: 22),


                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(127, 76, 175, 79),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Por seguridad, solo guardaremos los últimos 4 dígitos de tu tarjeta.',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.green[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final titular =
                                titularController.text.trim();

                            final numero =
                                numeroController.text
                                    .replaceAll(' ', '')
                                    .trim();

                            final expiracion =
                                expiracionController.text
                                    .trim();

                            if (titular.isEmpty) {
                              _mostrarMensaje(
                                context,
                                'Ingresa el nombre del titular.',
                                error: true,
                              );
                              return;
                            }

                            if (numero.length != 16) {
                              _mostrarMensaje(
                                context,
                                'El número debe tener 16 dígitos.',
                                error: true,
                              );
                              return;
                            }

                            if (!RegExp(
                              r'^\d{2}/\d{2}$',
                            ).hasMatch(expiracion)) {
                              _mostrarMensaje(
                                context,
                                'La fecha debe tener formato MM/AA.',
                                error: true,
                              );
                              return;
                            }

                            final ref =
                                _metodosPagoRef;

                            if (ref == null) {
                              _mostrarMensaje(
                                context,
                                'No hay un usuario autenticado.',
                                error: true,
                              );
                              return;
                            }

                            try {
                              await ref.add({
                                'titular': titular,
                                'ultimos4': numero.substring(
                                  numero.length - 4,
                                ),
                                'expiracion': expiracion,
                                'tipo': tipoTarjeta,
                                'predeterminada': false,
                                'fechaCreacion':
                                    FieldValue.serverTimestamp(),
                              });

                              if (modalContext.mounted) {
                                Navigator.pop(modalContext);
                              }

                              if (context.mounted) {
                                _mostrarMensaje(
                                  context,
                                  'Tarjeta guardada correctamente.',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                _mostrarMensaje(
                                  context,
                                  'No se pudo guardar la tarjeta.',
                                  error: true,
                                );
                              }
                            }
                          },
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: azul,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            'Guardar tarjeta',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // INPUT
  // =========================================================

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: azulOscuro,
      ),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: azul,
          width: 1.5,
        ),
      ),
    );
  }

  // =========================================================
  // TARJETA
  // =========================================================

  Widget _tarjetaPago(
    BuildContext context,
    Map<String, dynamic> data,
    String docId,
  ) {
    final tipo =
        data['tipo']?.toString() ?? 'Tarjeta';

    final ultimos4 =
        data['ultimos4']?.toString() ?? '0000';

    final titular =
        data['titular']?.toString() ?? '';

    final expiracion =
        data['expiracion']?.toString() ?? 'MM/AA';

    final predeterminada =
        data['predeterminada'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: azul.withOpacity(0.13),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.credit_card_rounded,
                    color: azulOscuro,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipo,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '•••• •••• •••• $ultimos4',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                  onSelected: (valor) async {
                    final ref =
                        _metodosPagoRef?.doc(docId);

                    if (valor == 'predeterminada') {
                      await _ponerComoPredeterminada(
                        docId,
                      );

                      if (context.mounted) {
                        _mostrarMensaje(
                          context,
                          'Tarjeta seleccionada como predeterminada.',
                        );
                      }
                    }

                    if (valor == 'eliminar') {
                      await ref?.delete();

                      if (context.mounted) {
                        _mostrarMensaje(
                          context,
                          'Tarjeta eliminada.',
                        );
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'predeterminada',
                      child: Text(
                        'Usar como predeterminada',
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'eliminar',
                      child: Text(
                        'Eliminar tarjeta',
                      ),
                    ),
                  ],
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _dato(
                      'Titular',
                      titular,
                    ),
                  ),
                  Expanded(
                    child: _dato(
                      'Vencimiento',
                      expiracion,
                    ),
                  ),
                ],
              ),
            ),

            if (predeterminada) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: azul.withOpacity(0.12),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✓ Tarjeta predeterminada',
                    style: GoogleFonts.nunito(
                      color: azulOscuro,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dato(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PREDETERMINADA
  // =========================================================

  Future<void> _ponerComoPredeterminada(
    String docId,
  ) async {
    final ref = _metodosPagoRef;

    if (ref == null) return;

    final snapshot = await ref.get();

    final batch =
        FirebaseFirestore.instance.batch();

    for (final doc in snapshot.docs) {
      batch.update(
        doc.reference,
        {
          'predeterminada':
              doc.id == docId,
        },
      );
    }

    await batch.commit();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final ref = _metodosPagoRef;

    return Scaffold(
      backgroundColor: fondo,

      appBar: AppBar(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 32,
          ),
        ),
        title: Text(
          'Métodos de pago',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        shape:
            const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(22),
          ),
        ),
      ),

      body: ref == null
          ? Center(
              child: Text(
                'Debes iniciar sesión para administrar tus tarjetas.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  color: Colors.grey,
                ),
              ),
            )
          : StreamBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
              stream: ref
                  .orderBy(
                    'fechaCreacion',
                    descending: true,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color: azul,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'No se pudieron cargar tus métodos de pago.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final docs =
                    snapshot.data?.docs ?? [];

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration:
                                BoxDecoration(
                              color:
                                  azul.withOpacity(
                                0.13,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),
                            child: const Icon(
                              Icons
                                  .account_balance_wallet_rounded,
                              color: azulOscuro,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Tus tarjetas',
                                  style:
                                      GoogleFonts.nunito(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Administra tus formas de pago',
                                  style:
                                      GoogleFonts.nunito(
                                    fontSize: 12,
                                    color:
                                        Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (docs.isEmpty)
                      Container(
                        padding:
                            const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(22),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              decoration:
                                  BoxDecoration(
                                color:
                                    azul.withOpacity(
                                  0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons
                                    .credit_card_off_rounded,
                                color: azulOscuro,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'No tienes tarjetas guardadas',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  GoogleFonts.nunito(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Agrega una tarjeta para tenerla disponible al momento de pagar.',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  GoogleFonts.nunito(
                                fontSize: 13,
                                color:
                                    Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...docs.map(
                        (doc) => _tarjetaPago(
                          context,
                          doc.data(),
                          doc.id,
                        ),
                      ),

                    const SizedBox(height: 90),
                  ],
                );
              },
            ),


      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
        onPressed: () =>
            _mostrarModalAgregarTarjeta(
          context,
        ),
        icon: const Icon(
          Icons.add_card_rounded,
        ),
        label: Text(
          ''
        ),
      ),
    );
  }
}