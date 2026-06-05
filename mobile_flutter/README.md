# Buki Booking Mobile Preview

Módulo opcional desarrollado en Flutter como *plus* para la prueba técnica de Buki Global. 
Demuestra cómo consumir la API existente de servicios y reservas (Node.js/Express) desde una aplicación móvil con diseño elegante y responsivo, completamente alineado al estilo de la aplicación web.

## Estado actual
Esta carpeta contiene la propuesta de código (`lib/main.dart` y dependencias base) para listar servicios y reservas con la misma jerarquía visual de la web Angular. 
**Importante:** Este módulo es solo un plus opcional y no bloquea el funcionamiento ni la evaluación de la prueba técnica principal.

## Instrucciones para ejecutar (Si tienes Flutter instalado)

1. Enciende tu backend Node.js en el puerto 3000 (revisa la carpeta `/backend`).
2. Abre una terminal en esta carpeta (`mobile_flutter`).
3. Descarga las dependencias necesarias:
   ```bash
   flutter pub get
   ```
4. Ejecuta la aplicación. Para verla rápidamente en Chrome tal como lo pidió el desafío:
   ```bash
   flutter run -d chrome
   ```

> **Nota para emuladores Android nativos:**  
> Por defecto, el código apunta a `http://localhost:3000/api` que funciona perfecto para pruebas en Web (Chrome) y en emuladores iOS. Si usas un emulador de Android oficial, cambia la constante `apiUrl` dentro de `main.dart` por `http://10.0.2.2:3000/api`.
