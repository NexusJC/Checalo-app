#  Chécalo

> App móvil para escanear códigos de barras y consultar precios en tiempo real según la tienda donde estás. Independiente de cualquier cadena comercial.

---

## ¿Qué es Chécalo?

Chécalo nace de una problemática cotidiana: los checadores de precio en tiendas como Walmart, Bodega Aurrera o Chedraui casi nunca están disponibles — están lejos, no sirven o simplemente no hay suficientes.

La solución es simple: usar el teléfono que ya traes en la bolsa. Escaneas el código de barras de cualquier producto y Chécalo te muestra el precio al instante, detectando automáticamente en qué tienda estás.

Sin depender de ninguna cadena. Para todos. Gratis.

---

##  Funcionalidades principales

-  **Escaneo de código de barras** desde la cámara del teléfono
-  **Detección automática de tienda** por GPS
-  **Consulta de precio en tiempo real** según la tienda donde estás
- ️ **Ofertas y promociones contextuales** de la tienda actual
-  **Historial de productos** escaneados

---

## ️ Tecnologías utilizadas

| Capa | Tecnología |
|---|---|
| App móvil | Flutter (iOS + Android) |
| Escaneo | ML Kit Barcode Scanning |
| GPS y tiendas | Google Places API |
| Catálogo de productos | Open Food Facts API |
| Base de datos | Firebase Firestore |
| Autenticación | Firebase Auth |
| Backend | Node.js / FastAPI |

---

## ️ Estructura del proyecto

```
checalo-app/
├── lib/
│   ├── pantallas/        # Vistas de la app
│   ├── componentes/      # Widgets reutilizables
│   ├── servicios/        # Lógica de negocio y APIs
│   ├── modelos/          # Modelos de datos
│   └── utilidades/       # Funciones de apoyo
├── assets/
│   ├── imagenes/
│   └── iconos/
├── test/                 # Pruebas unitarias
└── docs/                 # Documentación del proyecto
```

---

##  Cómo correr el proyecto

### Requisitos previos

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- Android Studio o VS Code
- Cuenta en Firebase

### Instalación

```bash
# Clona el repositorio
git clone https://github.com/tu-usuario/checalo-app.git

# Entra al proyecto
cd checalo-app

# Instala las dependencias
flutter pub get

# Corre la app
flutter run
```

### Variables de entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes claves:

```
FIREBASE_API_KEY=tu_clave_aqui
GOOGLE_PLACES_API_KEY=tu_clave_aqui
OPEN_FOOD_FACTS_URL=https://world.openfoodfacts.org/api/v2
```

---

## ️ Hoja de ruta

- [ ] MVP con escaneo básico y detección de tienda
- [ ] Integración con Open Food Facts
- [ ] Sistema de precios reportados por usuarios
- [ ] Primer convenio con tienda regional
- [ ] Publicidad contextual y ofertas
- [ ] Historial y lista del súper
- [ ] Versión iOS

---

##  Contribuciones

Este proyecto está abierto a contribuciones. Si quieres participar:

1. Haz un fork del repositorio
2. Crea una rama para tu cambio (`git checkout -b mejora/nombre-de-tu-mejora`)
3. Haz commit de tus cambios (`git commit -m "agrega nueva funcionalidad"`)
4. Sube tu rama (`git push origin mejora/nombre-de-tu-mejora`)
5. Abre un Pull Request

---

##  Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

> *"No más checadores rotos. El precio en tu mano."*