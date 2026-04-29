import 'package:flutter/material.dart';
import '../tema/colores.dart';

class PantallaCupones extends StatelessWidget {
  const PantallaCupones({super.key});

  // Datos de ejemplo — se reemplazarán con datos reales de la API
  static const List<Map<String, dynamic>> _cuponesEjemplo = [
    {
      'titulo': '2x1 en refrescos',
      'descripcion': 'Lleva 2 y paga 1 en cualquier refresco de 600ml',
      'vencimiento': '30 Abr 2026',
      'tienda': 'Walmart',
      'color': 0xFF0071CE,
      'activo': true,
    },
    {
      'titulo': '15% en lácteos',
      'descripcion': 'Descuento en toda la línea de productos Lala y Alpura',
      'vencimiento': '25 Abr 2026',
      'tienda': 'Bodega Aurrera',
      'color': 0xFF78BE20,
      'activo': true,
    },
    {
      'titulo': '\$50 en compras +\$500',
      'descripcion': 'Cupón de \$50 pesos en tu compra mayor a \$500',
      'vencimiento': '28 Abr 2026',
      'tienda': 'Chedraui',
      'color': 0xFFE31837,
      'activo': false,
    },
    {
      'titulo': '3x2 en botanas',
      'descripcion': 'Lleva 3 y paga 2 en botanas seleccionadas',
      'vencimiento': '01 May 2026',
      'tienda': 'Soriana',
      'color': 0xFFFF6600,
      'activo': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresChecalo.fondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: ColoresChecalo.primario.withOpacity(0.1),
            child: Row(
              children: [
                Icon(Icons.confirmation_number,
                    color: ColoresChecalo.primario, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Cupones disponibles',
                  style: TextStyle(
                    color: ColoresChecalo.primario,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ColoresChecalo.acento,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_cuponesEjemplo.where((c) => c['activo'] == true).length} activos',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de cupones
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _cuponesEjemplo.length,
              itemBuilder: (context, indice) {
                final cupon = _cuponesEjemplo[indice];
                return _TarjetaCupon(datos: cupon);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaCupon extends StatelessWidget {
  final Map<String, dynamic> datos;

  const _TarjetaCupon({required this.datos});

  @override
  Widget build(BuildContext context) {
    final bool activo = datos['activo'] as bool;
    final Color colorTienda = Color(datos['color'] as int);

    return Opacity(
      opacity: activo ? 1.0 : 0.5,
      child: Container(
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
        child: Row(
          children: [
            // Franja de color de la tienda (izquierda)
            Container(
              width: 8,
              height: 90,
              decoration: BoxDecoration(
                color: colorTienda,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),

            // Contenido del cupón
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Nombre de la tienda
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colorTienda.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            datos['tienda'] as String,
                            style: TextStyle(
                              color: colorTienda,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Estado del cupón
                        Text(
                          activo ? 'Disponible' : 'Usado',
                          style: TextStyle(
                            color: activo ? ColoresChecalo.exito : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      datos['titulo'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      datos['descripcion'] as String,
                      style: TextStyle(
                        color: ColoresChecalo.textoSecundario,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12, color: ColoresChecalo.textoSecundario),
                        const SizedBox(width: 4),
                        Text(
                          'Vence: ${datos['vencimiento']}',
                          style: TextStyle(
                            color: ColoresChecalo.textoSecundario,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}