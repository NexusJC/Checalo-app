import 'package:flutter/material.dart';
import '../tema/colores.dart';

class PantallaDescuentos extends StatelessWidget {
  const PantallaDescuentos({super.key});

  // Datos de ejemplo — se reemplazarán con datos reales de la API
  static const List<Map<String, dynamic>> _descuentosEjemplo = [
    {
      'producto': 'Coca-Cola 600ml',
      'precioAntes': 22.00,
      'precioAhora': 18.00,
      'descuento': '18%',
      'tienda': 'Walmart',
      'icono': Icons.local_drink,
    },
    {
      'producto': 'Pan Bimbo Grande',
      'precioAntes': 58.00,
      'precioAhora': 45.00,
      'descuento': '22%',
      'tienda': 'Bodega Aurrera',
      'icono': Icons.breakfast_dining,
    },
    {
      'producto': 'Leche Lala 1L',
      'precioAntes': 28.00,
      'precioAhora': 22.00,
      'descuento': '21%',
      'tienda': 'Chedraui',
      'icono': Icons.water_drop,
    },
    {
      'producto': 'Papel Higiénico Petalo x4',
      'precioAntes': 75.00,
      'precioAhora': 60.00,
      'descuento': '20%',
      'tienda': 'Soriana',
      'icono': Icons.cleaning_services,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresChecalo.fondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de tienda detectada
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: ColoresChecalo.primario.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.location_on, color: ColoresChecalo.primario, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Descuentos cerca de ti',
                  style: TextStyle(
                    color: ColoresChecalo.primario,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Lista de descuentos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _descuentosEjemplo.length,
              itemBuilder: (context, indice) {
                final descuento = _descuentosEjemplo[indice];
                return _TarjetaDescuento(datos: descuento);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaDescuento extends StatelessWidget {
  final Map<String, dynamic> datos;

  const _TarjetaDescuento({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Ícono del producto
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ColoresChecalo.primario.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                datos['icono'] as IconData,
                color: ColoresChecalo.primario,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Info del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    datos['producto'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    datos['tienda'] as String,
                    style: TextStyle(
                      color: ColoresChecalo.textoSecundario,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Precios
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(datos['precioAntes'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '\$${(datos['precioAhora'] as double).toStringAsFixed(2)}',
                  style: TextStyle(
                    color: ColoresChecalo.primario,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColoresChecalo.acento,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${datos['descuento']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}