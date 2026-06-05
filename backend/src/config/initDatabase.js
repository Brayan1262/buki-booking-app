const mysql = require('mysql2/promise');
require('dotenv').config({ path: __dirname + '/../../.env' }); // Ensure it loads from backend/.env

async function initializeDatabase() {
  try {
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || ''
    });

    const dbName = process.env.DB_NAME || 'buki_booking_db';

    // 1. Crear base de datos si no existe
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\`;`);
    
    // 2. Usar la base de datos
    await connection.query(`USE \`${dbName}\`;`);

    // 3. Crear tabla services
    await connection.query(`
      CREATE TABLE IF NOT EXISTS services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL,
        description TEXT,
        price DECIMAL(10,2) NOT NULL,
        duration INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // 4. Crear tabla bookings y relación
    await connection.query(`
      CREATE TABLE IF NOT EXISTS bookings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        client_name VARCHAR(150) NOT NULL,
        client_email VARCHAR(150) NOT NULL,
        service_id INT NOT NULL,
        booking_date DATE NOT NULL,
        booking_time TIME NOT NULL,
        status VARCHAR(50) DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (service_id) REFERENCES services(id)
      );
    `);

    console.log("Base de datos inicializada correctamente.");
    process.exit(0);
  } catch (error) {
    console.error("Error al inicializar base de datos. Revisa tus credenciales MySQL en backend/.env.");
    console.error(error); // Error técnico
    process.exit(1);
  }
}

initializeDatabase();
