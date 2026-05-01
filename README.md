# Chécalo 🏷️

¿Cuántas veces has buscado el precio de algo en el súper y el checador no sirve, está ocupado o simplemente no aparece por ningún lado? Chécalo nació de esa frustración.

Es una app que convierte tu teléfono en un checador de precios — escaneas el código de barras de cualquier producto y al instante sabes cuánto cuesta, en la tienda donde estás, sin depender de ninguna cadena en específico.

**Para todos. Gratis. Hecho en México. 🇲🇽**

---

## ¿Cómo funciona?

1. Abres la app y apuntas la cámara al código de barras
2. Chécalo detecta automáticamente en qué tienda estás usando el GPS
3. Te muestra el nombre del producto, su marca y el precio de esa tienda
4. Los colores y la publicidad de la app cambian según la tienda donde estás

Sin cuentas. Sin registro. Sin rollos.

---

## Lo que ya funciona ✅

- Escaneo de códigos de barras con la cámara del teléfono
- Identificación del producto con nombre, marca e imagen (Open Food Facts)
- Detección de tienda por GPS (Google Places API)
- Cambio de colores según la tienda detectada
- Indicador de conexión a internet en tiempo real
- Ícono y nombre propios de la app

## Lo que viene 🚧

- Precios reales por tienda (requiere convenios con las cadenas)
- Historial de productos escaneados
- Selección manual de tienda
- Descuentos y cupones contextuales
- Lista del súper con precios en tiempo real

---

## Stack tecnológico

| Qué | Con qué |
|---|---|
| App | Flutter — iOS y Android desde un solo código |
| Escaneo | mobile_scanner |
| Productos | Open Food Facts API |
| Ubicación | Google Places API + geolocator |
| Conexión | connectivity_plus |
| Estado global | provider |

---

## Cómo correrlo localmente

Necesitas Flutter instalado. Si no lo tienes: [flutter.dev](https://flutter.dev/docs/get-started/install)

```bash
git clone https://github.com/NexusJC/Checalo-app.git
cd Checalo-app
flutter pub get
flutter run
```

Antes de correrlo, crea un archivo `.env` en la raíz con tu API Key de Google:

---

## Estructura del proyecto

```
lib/
├── main.dart              — arranca la app y maneja navegación
├── pantallas/
│   ├── escaner.dart       — cámara, escaneo y resultado
│   ├── descuentos.dart    — ofertas de la tienda actual
│   └── cupones.dart       — cupones disponibles
├── servicios/
│   └── ubicacion.dart     — GPS y detección de tienda
├── estado/
│   └── estado_tienda.dart — estado global compartido
└── tema/
    └── colores.dart       — colores de Chécalo y de cada tienda
```

---

## Contribuciones

Si quieres aportar algo — un fix, una mejora, una idea — adelante:

```bash
git checkout -b mejora/lo-que-sea
git commit -m "descripción de lo que hiciste" 
git push origin mejora/lo-que-sea
```

Y abres un Pull Request. Así de sencillo.

---

## Licencia

MIT — úsalo, modifícalo, compártelo. Solo da crédito.

---

*"No más checadores rotos."*