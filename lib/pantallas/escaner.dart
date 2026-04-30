import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../tema/colores.dart';
import '../servicios/ubicacion.dart';

class PantallaEscaner extends StatefulWidget {
  const PantallaEscaner({super.key});

  @override
  State<PantallaEscaner> createState() => _PantallaEscanerState();
}

class _PantallaEscanerState extends State<PantallaEscaner>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _camaraController = MobileScannerController();

  bool _escaneando = true;
  String? _ultimoCodigoEscaneado;

  // Estado de la tienda detectada
  InfoTienda? _tiendaActual;
  String _mensajeTienda = 'Detectando tienda...';
  bool _buscandoTienda = true;

  late AnimationController _animacionController;
  late Animation<double> _animacionLinea;

  @override
  void initState() {
    super.initState();
    _animacionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animacionLinea = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animacionController, curve: Curves.easeInOut),
    );

    // Detectar tienda al abrir la pantalla
    _detectarTienda();
  }

  @override
  void dispose() {
    _animacionController.dispose();
    _camaraController.dispose();
    super.dispose();
  }

  // Detecta la tienda actual por GPS
  Future<void> _detectarTienda() async {
    setState(() {
      _buscandoTienda = true;
      _mensajeTienda = 'Detectando tienda...';
    });

    final tienda = await ServicioUbicacion.detectarTienda();

    if (mounted) {
      setState(() {
        _buscandoTienda = false;
        _tiendaActual = tienda;
        _mensajeTienda = tienda != null
            ? tienda.nombre
            : 'Tienda no detectada';
      });
    }
  }

  void _onCodigoDetectado(BarcodeCapture captura) {
    if (!_escaneando) return;
    final codigo = captura.barcodes.firstOrNull?.rawValue;
    if (codigo == null || codigo == _ultimoCodigoEscaneado) return;

    setState(() {
      _escaneando = false;
      _ultimoCodigoEscaneado = codigo;
    });

    _consultarProducto(codigo);
  }

  Future<void> _consultarProducto(String codigo) async {
    _mostrarResultado(codigo, null, null, null, cargando: true);

    try {
      final url = Uri.parse(
        'https://world.openfoodfacts.org/api/v2/product/$codigo?fields=product_name,product_name_es,brands,image_front_small_url',
      );
      final respuesta = await http.get(url).timeout(const Duration(seconds: 8));

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        if (datos['status'] == 1) {
          final producto = datos['product'];
          final nombre = (producto['product_name_es'] ??
              producto['product_name'] ??
              'Producto desconocido')
              .toString();
          final marca = (producto['brands'] ?? '').toString();
          final imagen = producto['image_front_small_url']?.toString();

          if (mounted) Navigator.pop(context);
          _mostrarResultado(codigo, nombre, marca, imagen);
          return;
        }
      }

      if (mounted) Navigator.pop(context);
      _mostrarResultado(codigo, 'Producto no encontrado', '', null);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _mostrarResultado(codigo, 'Sin conexión', '', null);
    }
  }

  void _mostrarResultado(
      String codigo,
      String? nombre,
      String? marca,
      String? imagen, {
        bool cargando = false,
      }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: !cargando,
      builder: (context) => cargando
          ? _PanelCargando()
          : _PanelResultado(
        codigo: codigo,
        nombre: nombre ?? 'Desconocido',
        marca: marca ?? '',
        imagen: imagen,
        tienda: _tiendaActual,
        onEscanearOtro: () {
          Navigator.pop(context);
          setState(() {
            _escaneando = true;
            _ultimoCodigoEscaneado = null;
          });
        },
      ),
    );
  }

  // Color del indicador de tienda según la tienda detectada
  Color get _colorTienda {
    if (_tiendaActual == null) return ColoresChecalo.acento;
    return ColoresChecalo.obtenerColorTienda(_tiendaActual!.tipo);
  }

  @override
  Widget build(BuildContext context) {
    final tamanoPantalla = MediaQuery.of(context).size;

    return Stack(
      children: [
        MobileScanner(
          controller: _camaraController,
          onDetect: _onCodigoDetectado,
        ),

        Container(color: Colors.black.withValues(alpha: 0.4)),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _escaneando ? 'Apunta al código de barras' : 'Procesando...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Rectángulo de escaneo
              Container(
                width: tamanoPantalla.width * 0.75,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    _Esquina(alineacion: Alignment.topLeft),
                    _Esquina(alineacion: Alignment.topRight),
                    _Esquina(alineacion: Alignment.bottomLeft),
                    _Esquina(alineacion: Alignment.bottomRight),
                    if (_escaneando)
                      AnimatedBuilder(
                        animation: _animacionLinea,
                        builder: (context, child) {
                          return Positioned(
                            top: _animacionLinea.value * 140,
                            left: 8,
                            right: 8,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    _colorTienda,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Indicador de tienda detectada
              GestureDetector(
                onTap: _detectarTienda,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _colorTienda.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_buscandoTienda)
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            color: _colorTienda,
                            strokeWidth: 2,
                          ),
                        )
                      else
                        Icon(Icons.location_on,
                            color: _colorTienda, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _mensajeTienda,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13),
                      ),
                      if (!_buscandoTienda) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.refresh,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 14),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Botón linterna
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            onPressed: () => _camaraController.toggleTorch(),
            icon: const Icon(Icons.flashlight_on,
                color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }
}

class _PanelCargando extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: ColoresChecalo.primario),
          const SizedBox(height: 16),
          Text(
            'Buscando producto...',
            style: TextStyle(
                color: ColoresChecalo.textoSecundario, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _PanelResultado extends StatelessWidget {
  final String codigo;
  final String nombre;
  final String marca;
  final String? imagen;
  final InfoTienda? tienda;
  final VoidCallback onEscanearOtro;

  const _PanelResultado({
    required this.codigo,
    required this.nombre,
    required this.marca,
    required this.imagen,
    required this.tienda,
    required this.onEscanearOtro,
  });

  @override
  Widget build(BuildContext context) {
    final colorTienda = tienda != null
        ? ColoresChecalo.obtenerColorTienda(tienda!.tipo)
        : ColoresChecalo.primario;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imagen != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagen!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    ),
                  ),
                )
                    : Icon(Icons.inventory_2,
                    color: Colors.grey[400], size: 36),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (marca.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        marca,
                        style: TextStyle(
                          color: ColoresChecalo.textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        codigo,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Precio con color de la tienda
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorTienda.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorTienda.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: colorTienda, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      tienda != null
                          ? tienda!.nombre
                          : 'Tienda no detectada',
                      style: TextStyle(
                        color: colorTienda,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '\$---.--',
                  style: TextStyle(
                    color: colorTienda,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Precio disponible próximamente',
                  style: TextStyle(
                      color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEscanearOtro,
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text(
                'Escanear otro producto',
                style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorTienda,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Esquina extends StatelessWidget {
  final Alignment alineacion;
  const _Esquina({required this.alineacion});

  @override
  Widget build(BuildContext context) {
    final esIzquierda = alineacion == Alignment.topLeft ||
        alineacion == Alignment.bottomLeft;
    final esArriba =
        alineacion == Alignment.topLeft || alineacion == Alignment.topRight;

    return Positioned(
      top: esArriba ? 0 : null,
      bottom: !esArriba ? 0 : null,
      left: esIzquierda ? 0 : null,
      right: !esIzquierda ? 0 : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: esArriba
                ? BorderSide(color: ColoresChecalo.acento, width: 3)
                : BorderSide.none,
            bottom: !esArriba
                ? BorderSide(color: ColoresChecalo.acento, width: 3)
                : BorderSide.none,
            left: esIzquierda
                ? BorderSide(color: ColoresChecalo.acento, width: 3)
                : BorderSide.none,
            right: !esIzquierda
                ? BorderSide(color: ColoresChecalo.acento, width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}