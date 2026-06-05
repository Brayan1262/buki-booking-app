# Buki Booking API

Backend base para la aplicación de reservas Buki.

## Tecnologías
- Node.js
- Express
- MySQL

## Instalación
Para instalar las dependencias del proyecto:
```bash
npm install
```

## Configuración
1. Copiar el archivo `.env.example` y renombrarlo a `.env`.
2. Configurar las variables de entorno de la base de datos en el archivo `.env`.

## Ejecución
Para iniciar el servidor en modo desarrollo con nodemon:
```bash
npm run dev
```

## Endpoints Disponibles Inicialmente
- `GET /api/health`: Retorna el estado de salud de la API.
- `GET /`: Endpoint raíz que indica que la API está en ejecución.
