import 'package:flutter/material.dart';

/// Colores propios de Chécalo
/// Los colores de la app cambiarán según la tienda detectada,
/// pero estos son los colores base de la marca Chécalo.
class ColoresChecalo {
  // Color primario de Chécalo — verde mexicano
  static const Color primario = Color(0xFF1A7A4A);

  // Color de acento — naranja vibrante
  static const Color acento = Color(0xFFFF6B2B);

  // Fondo claro
  static const Color fondo = Color(0xFFF5F5F5);

  // Texto principal
  static const Color textoPrincipal = Color(0xFF1A1A1A);

  // Texto secundario
  static const Color textoSecundario = Color(0xFF666666);

  // Color de éxito (precio encontrado)
  static const Color exito = Color(0xFF2ECC71);

  // Color de error
  static const Color error = Color(0xFFE74C3C);

  // Colores por tienda (se usarán cuando el GPS detecte la tienda)
  static const Map<String, Color> coloresTienda = {
    'walmart': Color(0xFF0071CE),
    'bodega_aurrera': Color(0xFF78BE20),
    'chedraui': Color(0xFFE31837),
    'soriana': Color(0xFFFF6600),
    'la_comer': Color(0xFF6B2D8B),
  };

  /// Obtiene el color de la tienda actual o el color primario de Chécalo
  static Color obtenerColorTienda(String? tienda) {
    if (tienda == null) return primario;
    return coloresTienda[tienda] ?? primario;
  }
}