# Buki Booking App

## Descripción
Mini aplicación full-stack desarrollada como prueba técnica para Buki Global. Permite registrar servicios, listar servicios, crear reservas asociadas a un servicio y visualizar reservas con información del cliente y del servicio.

## Tecnologías utilizadas

Frontend:
- Angular
- TypeScript
- Bootstrap
- Bootstrap Icons

Backend:
- Node.js
- Express
- MySQL2
- CORS
- dotenv

Base de datos:
- MySQL

Mobile opcional:
- Flutter
- Dart

## Requisitos previos

El evaluador debe tener instalado:
- Git
- Node.js
- MySQL Server
- Angular CLI opcional
- Flutter opcional solo si desea revisar mobile_flutter

Aclarar:
El proyecto no incluye una base de datos local. Cada evaluador debe tener MySQL instalado, configurar sus credenciales en `backend/.env` y ejecutar `npm run db:init` para crear automáticamente la base de datos y las tablas necesarias.

## Clonar repositorio

```bash
git clone https://github.com/Brayan1262/buki-booking-app.git
cd buki-booking-app
```

## Configurar backend

```bash
cd backend
npm install
```

Copiar `.env.example` a `.env`:

En Windows:
```cmd
copy .env.example .env
```

Luego editar `backend/.env` con las credenciales locales de MySQL del evaluador:

```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=su_password_mysql
DB_NAME=buki_booking_db
```

Aclarar:
El archivo `.env` real no se sube al repositorio por seguridad. Cada evaluador debe colocar su propia contraseña de MySQL.

## Crear base de datos

Opción recomendada:

```bash
npm run db:init
```

Explicar que este comando crea:
- `buki_booking_db`
- tabla `services`
- tabla `bookings`
- relación `bookings.service_id` con `services.id`

Opción manual:
Ejecutar `database/schema.sql` desde MySQL Workbench o MySQL Command Line.

## Ejecutar backend

```bash
npm run dev
```

Backend disponible en:
http://localhost:3000

Probar:
http://localhost:3000/
http://localhost:3000/api/health

## Ejecutar frontend

Abrir otra terminal desde la raíz del proyecto:

```bash
cd frontend
npm install
ng serve
```

Frontend disponible en:
http://localhost:4200

## Flujo de prueba

1. Abrir http://localhost:4200
2. Registrar un servicio con nombre, descripción, precio y duración.
3. Verificar que el servicio aparece en el listado.
4. Crear una reserva seleccionando el servicio creado.
5. Verificar que la reserva aparece con datos del cliente y del servicio asociado.

## Endpoints principales

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| GET | `/api/health` | Verifica estado de la API |
| GET | `/api/services` | Lista servicios registrados |
| POST | `/api/services` | Crea un servicio |
| GET | `/api/bookings` | Lista reservas con datos del servicio |
| POST | `/api/bookings` | Crea una reserva |

## Ejemplos con curl

Crear servicio:

```bash
curl -X POST http://localhost:3000/api/services -H "Content-Type: application/json" -d "{\"name\":\"Corte de cabello\",\"description\":\"Servicio de corte y asesoría de estilo\",\"price\":35,\"duration\":45}"
```

Crear reserva:

```bash
curl -X POST http://localhost:3000/api/bookings -H "Content-Type: application/json" -d "{\"client_name\":\"Maria Lopez\",\"client_email\":\"maria@gmail.com\",\"service_id\":1,\"booking_date\":\"2026-06-06\",\"booking_time\":\"10:30\"}"
```

## Validaciones implementadas

Servicios:
- Nombre obligatorio.
- Precio numérico y mayor o igual a 0.
- Duración numérica y mayor a 0.

Reservas:
- Nombre del cliente obligatorio.
- Correo obligatorio y válido.
- Servicio obligatorio y existente.
- Fecha obligatoria.
- Hora obligatoria.

## Flutter opcional

Aclarar:
El módulo `mobile_flutter` es un plus opcional. No es necesario para revisar la solución principal.

Para ejecutarlo:

```bash
cd mobile_flutter
flutter pub get
flutter run -d chrome
```

Requiere backend encendido en:
http://localhost:3000

## Alcance no implementado

Por alcance de la prueba no se implementó:
- autenticación
- roles
- pagos
- notificaciones
- deploy
- edición/eliminación avanzada
- pruebas automatizadas obligatorias

## Autor

Brayan Jair Chavez Oscor

## Nota final

Este proyecto prioriza funcionalidad, integración, orden y facilidad de revisión, acorde al perfil practicante/junior solicitado.
