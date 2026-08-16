import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartFavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  // =========================================================
  // CARRITO
  // =========================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>> obtenerCarritoStream() {
    if (_uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('carrito')
        .snapshots();
  }

  static Future<void> agregarAlCarrito(
    Map<String, dynamic> producto,
  ) async {
    if (_uid == null) return;

    final sku = producto['sku']?.toString().trim() ?? '';

    if (sku.isEmpty) return;

    final docRef = _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('carrito')
        .doc(sku);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data();

      final cantidadActual = (data?['cantidad'] as num?)?.toInt() ?? 1;

      await docRef.update({
        'cantidad': cantidadActual + 1,
      });

      return;
    }

    await docRef.set({
      'sku': sku,
      'nombre': producto['nombre']?.toString() ?? '',
      'precio': producto['precio']?.toString() ?? '',
      'marca': producto['marca']?.toString() ?? '',
      'imagen': producto['imagen']?.toString() ?? '',
      'imagenes': producto['imagenes'] ?? [],
      'puntuacion': (producto['puntuacion'] as num?)?.toDouble() ?? 0.0,
      'comentarios': (producto['comentarios'] as num?)?.toInt() ?? 0,
      'disponibles': (producto['disponibles'] as num?)?.toInt() ?? 0,
      'descripcion': producto['descripcion']?.toString() ?? '',
      'modelo': producto['modelo']?.toString() ?? '',
      'especificaciones': producto['especificaciones'] ?? [],
      'cantidad': 1,
    });
  }

  static Future<void> actualizarCantidad(
    String idDoc,
    int nuevaCantidad,
  ) async {
    if (_uid == null) return;

    if (nuevaCantidad <= 0) {
      await eliminarDelCarrito(idDoc);
      return;
    }

    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('carrito')
        .doc(idDoc)
        .update({
      'cantidad': nuevaCantidad,
    });
  }

  static Future<void> eliminarDelCarrito(
    String idDoc,
  ) async {
    if (_uid == null) return;

    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('carrito')
        .doc(idDoc)
        .delete();
  }

  static Future<void> vaciarCarrito() async {
    if (_uid == null) return;

    final snapshot = await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('carrito')
        .get();

    final batch = _firestore.batch();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // =========================================================
  // FAVORITOS
  // =========================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>> obtenerFavoritosStream() {
    if (_uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .snapshots();
  }

  static Future<void> agregarFavorito(
    Map<String, dynamic> producto,
  ) async {
    if (_uid == null) return;

    final sku = producto['sku']?.toString().trim() ?? '';

    if (sku.isEmpty) return;

    final docRef = _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .doc(sku);

    await docRef.set({
      'sku': sku,
      'nombre': producto['nombre']?.toString() ?? '',
      'precio': producto['precio']?.toString() ?? '',
      'marca': producto['marca']?.toString() ?? '',
      'imagen': producto['imagen']?.toString() ?? '',
      'imagenes': producto['imagenes'] ?? [],
      'puntuacion': (producto['puntuacion'] as num?)?.toDouble() ?? 0.0,
      'comentarios': (producto['comentarios'] as num?)?.toInt() ?? 0,
      'disponibles': (producto['disponibles'] as num?)?.toInt() ?? 0,
      'descripcion': producto['descripcion']?.toString() ?? '',
      'modelo': producto['modelo']?.toString() ?? '',
      'especificaciones': producto['especificaciones'] ?? [],
    });
  }

  static Future<void> eliminarFavorito(
    String sku,
  ) async {
    if (_uid == null) return;

    final skuLimpio = sku.trim();

    if (skuLimpio.isEmpty) return;

    await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .doc(skuLimpio)
        .delete();
  }

  static Future<bool> toggleFavorito(
    Map<String, dynamic> producto,
  ) async {
    if (_uid == null) return false;

    final sku = producto['sku']?.toString().trim() ?? '';

    if (sku.isEmpty) return false;

    final docRef = _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .doc(sku);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      await docRef.delete();
      return false;
    }

    await agregarFavorito(producto);

    return true;
  }

  static Future<bool> esFavorito(
    String sku,
  ) async {
    if (_uid == null) return false;

    final skuLimpio = sku.trim();

    if (skuLimpio.isEmpty) return false;

    final snapshot = await _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('favoritos')
        .doc(skuLimpio)
        .get();

    return snapshot.exists;
  }

  // =========================================================
  // PEDIDOS
  // =========================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>> obtenerPedidosStream() {
    if (_uid == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('pedidos')
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  // =========================================================
  // CREAR PEDIDO
  // =========================================================

  static Future<String?> crearPedido({
    required List<Map<String, dynamic>> productos,
    required double subtotal,
    required double envio,
    required double total,
    String estado = 'Pendiente',
  }) async {
    if (_uid == null) return null;

    final pedidoRef = _firestore
        .collection('usuarios')
        .doc(_uid)
        .collection('pedidos')
        .doc();

    await pedidoRef.set({
      'idPedido': pedidoRef.id,
      'productos': productos,
      'subtotal': subtotal,
      'envio': envio,
      'total': total,
      'estado': estado,
      'fecha': FieldValue.serverTimestamp(),
    });

    return pedidoRef.id;
  }
}