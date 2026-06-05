# Buki Booking App

Mini aplicación full-stack desarrollada como prueba técnica para **Buki Global**.
El objetivo de este proyecto es demostrar capacidades de desarrollo integrando una arquitectura limpia y conectando un frontend en Angular con un backend en Node.js, almacenando datos en MySQL.

## Tecnologías

- **Frontend:** Angular 18, Bootstrap 5, Bootstrap Icons
- **Backend:** Node.js, Express
- **Base de Datos:** MySQL
- **Diseño:** Inspirado en el sistema visual de Buki (tonos lila, morado y blanco)

## Estructura del Proyecto

- `/backend`: Servidor API REST.
- `/frontend`: Aplicación cliente Angular.
- `/database`: Scripts SQL de estructura (schema.sql).

## Estado Actual

- **Backend:** Configurado, conectado a BD y sirviendo endpoints CRUD para `services` y `bookings`.
- **Frontend:** Completo y funcional, con diseño responsive y comunicación fluida con la API REST.

## Cómo Ejecutar

1. **Backend:**
   ```bash
   cd backend
   npm install
   npm run dev
   ```
   *Estará corriendo en `http://localhost:3000`*

2. **Frontend:**
   ```bash
   cd frontend
   npm install
   ng serve
   ```
   *Estará corriendo en `http://localhost:4200`*
