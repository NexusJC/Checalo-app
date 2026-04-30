import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'pantallas/escaner.dart';
import 'pantallas/descuentos.dart';
import 'pantallas/cupones.dart';
import 'tema/colores.dart';
import 'estado/estado_tienda.dart';

void main() {
  runApp(
    // Provider envuelve toda la app para compartir el estado de la tienda
    ChangeNotifierProvider(
      create: (_) => EstadoTienda(),
      child: const CheckaloApp(),
    ),
  );
}

class CheckaloApp extends StatelessWidget {
  const CheckaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha el color de la tienda para el tema
    final colorTienda = context.watch<EstadoTienda>().colorPrimario;

    return MaterialApp(
      title: 'Chécalo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorTienda),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PantallaBase(),
    );
  }
}

class PantallaBase extends StatefulWidget {
  const PantallaBase({super.key});

  @override
  State<PantallaBase> createState() => _PantallaBaseState();
}

class _PantallaBaseState extends State<PantallaBase> {
  int _indiceActual = 1;

  EstadoConexion _estadoConexion = EstadoConexion.verificando;
  StreamSubscription? _suscripcionConexion;

  final List<Widget> _pantallas = [
    const PantallaDescuentos(),
    const PantallaEscaner(),
    const PantallaCupones(),
  ];

  @override
  void initState() {
    super.initState();
    _verificarConexion();
    _escucharCambiosDeRed();
  }

  @override
  void dispose() {
    _suscripcionConexion?.cancel();
    super.dispose();
  }

  Future<void> _verificarConexion() async {
    setState(() => _estadoConexion = EstadoConexion.verificando);
    await Future.delayed(const Duration(milliseconds: 800));
    final resultado = await Connectivity().checkConnectivity();
    _actualizarEstado(resultado);
  }

  void _escucharCambiosDeRed() {
    _suscripcionConexion =
        Connectivity().onConnectivityChanged.listen((resultado) {
          _actualizarEstado(resultado);
        });
  }

  void _actualizarEstado(List<ConnectivityResult> resultado) {
    final tieneConexion = resultado.any((r) =>
    r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);

    setState(() {
      _estadoConexion = tieneConexion
          ? EstadoConexion.conectado
          : EstadoConexion.sinConexion;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escucha cambios de tienda para actualizar colores
    final estadoTienda = context.watch<EstadoTienda>();
    final colorPrimario = estadoTienda.colorPrimario;
    final colorAcento = estadoTienda.colorAcento;
    final nombreTienda = estadoTienda.nombreCorto;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimario,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorAcento,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              child: Text(nombreTienda),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          _BannerConexion(
              estado: _estadoConexion, onReintentar: _verificarConexion),
          Expanded(
            child: _estadoConexion == EstadoConexion.sinConexion
                ? _PantallaSinConexion(onReintentar: _verificarConexion)
                : _pantallas[_indiceActual],
          ),
        ],
      ),

      bottomNavigationBar: _estadoConexion == EstadoConexion.sinConexion
          ? null
          : Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BotonNavegacion(
                  icono: Icons.local_offer_outlined,
                  iconoActivo: Icons.local_offer,
                  etiqueta: 'Descuentos',
                  activo: _indiceActual == 0,
                  colorActivo: colorPrimario,
                  onTap: () => setState(() => _indiceActual = 0),
                ),
                const SizedBox(width: 60),
                _BotonNavegacion(
                  icono: Icons.confirmation_number_outlined,
                  iconoActivo: Icons.confirmation_number,
                  etiqueta: 'Cupones',
                  activo: _indiceActual == 2,
                  colorActivo: colorPrimario,
                  onTap: () => setState(() => _indiceActual = 2),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: _estadoConexion == EstadoConexion.sinConexion
          ? null
          : FloatingActionButton(
        onPressed: () => setState(() => _indiceActual = 1),
        backgroundColor:
        _indiceActual == 1 ? colorPrimario : colorAcento,
        elevation: _indiceActual == 1 ? 8 : 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

enum EstadoConexion { verificando, conectado, sinConexion }

class _BannerConexion extends StatelessWidget {
  final EstadoConexion estado;
  final VoidCallback onReintentar;

  const _BannerConexion({required this.estado, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    if (estado == EstadoConexion.conectado) return const SizedBox.shrink();

    final esVerificando = estado == EstadoConexion.verificando;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      color: esVerificando ? Colors.orange[700] : Colors.red[700],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (esVerificando)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
          else
            const Icon(Icons.wifi_off, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            esVerificando
                ? 'Verificando conexión...'
                : 'Sin conexión a internet',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
          if (!esVerificando) ...[
            const Spacer(),
            GestureDetector(
              onTap: onReintentar,
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PantallaSinConexion extends StatelessWidget {
  final VoidCallback onReintentar;

  const _PantallaSinConexion({required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColoresChecalo.fondo,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.wifi_off_rounded,
                    size: 52, color: Colors.red[400]),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sin conexión a internet',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Chécalo necesita internet para consultar precios y productos. Conéctate a una red WiFi o activa tus datos móviles.',
                style: TextStyle(
                    fontSize: 14,
                    color: ColoresChecalo.textoSecundario,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColoresChecalo.primario,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonNavegacion extends StatelessWidget {
  final IconData icono;
  final IconData iconoActivo;
  final String etiqueta;
  final bool activo;
  final Color colorActivo;
  final VoidCallback onTap;

  const _BotonNavegacion({
    required this.icono,
    required this.iconoActivo,
    required this.etiqueta,
    required this.activo,
    required this.colorActivo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            activo ? iconoActivo : icono,
            color: activo ? colorActivo : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 11,
              color: activo ? colorActivo : Colors.grey,
              fontWeight:
              activo ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}