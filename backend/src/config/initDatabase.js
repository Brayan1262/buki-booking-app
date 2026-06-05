const mysql = require('mysql2/promise');
require('dotenv').config();

const initializeDB = async () => {
  try {
    // Conectar sin seleccionar la base de datos específica
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD !== undefined ? process.env.DB_PASSWORD : ''
    });

    const dbName = process.env.DB_NAME || 'buki_booking_db';

    // 1. Crear base de datos
    await connection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);

    // 2. Usar la base de datos
    await connection.query(`USE \`${dbName}\``);

    // 3. Crear tabla services
    await connection.query(`
      CREATE TABLE IF NOT EXISTS services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL,
        description TEXT,
        price DECIMAL(10,2) NOT NULL,
        duration INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // 4. Crear tabla bookings
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
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    `);

    console.log("Base de datos inicializada correctamente");
    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error("Error al inicializar base de datos");
    console.error(error);
    process.exit(1);
  }
};

initializeDB();
