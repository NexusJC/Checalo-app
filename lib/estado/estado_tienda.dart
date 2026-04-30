import 'package:flutter/material.dart';
import '../tema/colores.dart';
import '../servicios/ubicacion.dart';

/// Estado global de la tienda detectada
/// Todas las pantallas pueden escuchar cambios aquí
class EstadoTienda extends ChangeNotifier {
  InfoTienda? _tiendaActual;
  bool _cargando = false;

  InfoTienda? get tiendaActual => _tiendaActual;
  bool get cargando => _cargando;

  // Nombre a mostrar en la UI
  String get nombreTienda {
    if (_cargando) return 'Detectando tienda...';
    if (_tiendaActual == null) return 'Tienda no detectada';
    return _tiendaActual!.nombre;
  }

  // Color primario según la tienda
  Color get colorPrimario {
    if (_tiendaActual == null) return ColoresChecalo.primario;
    return ColoresChecalo.obtenerColorTienda(_tiendaActual!.tipo);
  }

  // Color de acento según la tienda
  Color get colorAcento {
    if (_tiendaActual == null) return ColoresChecalo.acento;
    // Cada tienda tiene su propio acento
    final acentos = {
      'walmart': const Color(0xFFFFC220),
      'bodega_aurrera': const Color(0xFF005A28),
      'chedraui': const Color(0xFFFFD700),
      'soriana': const Color(0xFFCC0000),
      'la_comer': const Color(0xFF4A1A6B),
      'city_market': const Color(0xFF4A1A6B),
    };
    return acentos[_tiendaActual!.tipo] ?? ColoresChecalo.acento;
  }

  // Nombre corto para mostrar en encabezado
  String get nombreCorto {
    if (_tiendaActual == null) return 'Chécalo';
    final nombres = {
      'walmart': 'Walmart',
      'bodega_aurrera': 'Bodega Aurrera',
      'chedraui': 'Chedraui',
      'soriana': 'Soriana',
      'la_comer': 'La Comer',
      'city_market': 'City Market',
      'oxxo': 'OXXO',
      'seven_eleven': '7-Eleven',
      'sams_club': "Sam's Club",
      'costco': 'Costco',
    };
    return nombres[_tiendaActual!.tipo] ?? _tiendaActual!.nombre;
  }

  // Detecta la tienda y notifica a toda la app
  Future<void> detectar() async {
    _cargando = true;
    notifyListeners();

    final tienda = await ServicioUbicacion.detectarTienda();

    _tiendaActual = tienda;
    _cargando = false;
    notifyListeners();
  }

  // Limpia la tienda detectada
  void limpiar() {
    _tiendaActual = null;
    notifyListeners();
  }
}