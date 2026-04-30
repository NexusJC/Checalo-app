import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Información de la tienda detectada
class InfoTienda {
  final String nombre;
  final String tipo;
  final double distanciaMetros;

  const InfoTienda({
    required this.nombre,
    required this.tipo,
    required this.distanciaMetros,
  });
}

/// Servicio de ubicación y detección de tienda por GPS
class ServicioUbicacion {
  // Tu API Key de Google — en producción esto va en un archivo seguro
  static const String _apiKey = 'AIzaSyAuzFsg5EczTtwcgwTXBraJzjKFYVrq-Co';

  // Nombres de tiendas que reconocemos en México
  static const List<String> _tiendasConocidas = [
    'walmart',
    'bodega aurrera',
    'chedraui',
    'soriana',
    'la comer',
    'city market',
    'fresko',
    'oxxo',
    'seven eleven',
    '7-eleven',
    'superama',
    'sam\'s club',
    'costco',
    'comercial mexicana',
    'mega',
  ];

  /// Verifica y solicita permisos de ubicación
  static Future<bool> verificarPermisos() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) return false;

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) return false;
    }

    if (permiso == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Obtiene la posición actual del teléfono
  static Future<Position?> obtenerPosicion() async {
    final tienePermiso = await verificarPermisos();
    if (!tienePermiso) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Detecta en qué tienda estás usando Google Places API
  static Future<InfoTienda?> detectarTienda() async {
    final posicion = await obtenerPosicion();
    if (posicion == null) return null;

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${posicion.latitude},${posicion.longitude}'
        '&radius=50'
        '&type=supermarket|grocery_or_supermarket|convenience_store'
        '&key=$_apiKey',
      );

      final respuesta = await http.get(url).timeout(const Duration(seconds: 8));

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        final resultados = datos['results'] as List;

        if (resultados.isNotEmpty) {
          final lugar = resultados.first;
          final nombre = lugar['name'] as String;
          final tipo = (lugar['types'] as List).first.toString();

          // Calcular distancia
          final lat = lugar['geometry']['location']['lat'] as double;
          final lng = lugar['geometry']['location']['lng'] as double;
          final distancia = Geolocator.distanceBetween(
            posicion.latitude,
            posicion.longitude,
            lat,
            lng,
          );

          return InfoTienda(
            nombre: nombre,
            tipo: _normalizarTienda(nombre),
            distanciaMetros: distancia,
          );
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Normaliza el nombre de la tienda para usarlo como identificador
  static String _normalizarTienda(String nombre) {
    final nombreLower = nombre.toLowerCase();

    for (final tienda in _tiendasConocidas) {
      if (nombreLower.contains(tienda)) {
        return tienda.replaceAll(' ', '_');
      }
    }

    return 'desconocida';
  }

  /// Devuelve un mensaje amigable según el estado del GPS
  static Future<String> obtenerMensajeUbicacion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) return 'GPS desactivado';

    final permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      return 'Permiso de ubicación denegado';
    }

    return 'Detectando tienda...';
  }
}
