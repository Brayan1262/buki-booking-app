CREATE DATABASE IF NOT EXISTS buki_booking_db;
USE buki_booking_db;

CREATE TABLE IF NOT EXISTS services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    duration INT NOT NULL COMMENT 'Duration in minutes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL,
    service_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

-- Datos de ejemplo opcionales para pruebas
INSERT INTO services (name, description, price, duration) VALUES
('Corte de Cabello', 'Corte de cabello clásico para hombre o mujer', 15.00, 30),
('Manicura Spa', 'Manicura completa con exfoliación y esmaltado', 20.00, 45),
('Masaje Relajante', 'Masaje de cuerpo completo para aliviar el estrés', 40.00, 60);

INSERT INTO bookings (client_name, client_email, service_id, booking_date, booking_time, status) VALUES
('Juan Perez', 'juan.perez@example.com', 1, '2026-06-10', '10:00:00', 'pending'),
('Maria Lopez', 'maria.lopez@example.com', 2, '2026-06-11', '14:30:00', 'pending');
