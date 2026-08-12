class FavoritosService {
  static final List<Map<String, String>> favoritos = [];

  static void agregar(Map<String, String> producto) {
    final existe = favoritos.any(
      (item) => item['nombre'] == producto['nombre'],
    );

    if (!existe) {
      favoritos.add(producto);
    }
  }

  static void eliminar(String nombre) {
    favoritos.removeWhere(
      (item) => item['nombre'] == nombre,
    );
  }

  static bool esFavorito(String nombre) {
    return favoritos.any(
      (item) => item['nombre'] == nombre,
    );
  }
}