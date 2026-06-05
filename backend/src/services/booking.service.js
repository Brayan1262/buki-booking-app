const { pool } = require('../config/db');

const getAllBookings = async () => {
  const query = `
    SELECT 
      b.id,
      b.client_name,
      b.client_email,
      b.service_id,
      s.name AS service_name,
      s.price AS service_price,
      s.duration AS service_duration,
      DATE_FORMAT(b.booking_date, '%Y-%m-%d') AS booking_date,
      b.booking_time,
      b.status,
      b.created_at
    FROM bookings b
    JOIN services s ON b.service_id = s.id
    ORDER BY b.id DESC
  `;
  const [rows] = await pool.query(query);
  return rows;
};

const createBooking = async (bookingData) => {
  const { client_name, client_email, service_id, booking_date, booking_time } = bookingData;

  // Validaciones
  if (!client_name || client_name.trim() === '') {
    throw { status: 400, message: 'El nombre del cliente es obligatorio' };
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!client_email || !emailRegex.test(client_email)) {
    throw { status: 400, message: 'El correo del cliente no es válido' };
  }

  if (!service_id) {
    throw { status: 400, message: 'Debe seleccionar un servicio' };
  }

  if (!booking_date || booking_date.trim() === '') {
    throw { status: 400, message: 'La fecha de reserva es obligatoria' };
  }

  if (!booking_time || booking_time.trim() === '') {
    throw { status: 400, message: 'La hora de reserva es obligatoria' };
  }

  // Verificar si el servicio existe
  const [services] = await pool.query('SELECT id FROM services WHERE id = ?', [service_id]);
  if (services.length === 0) {
    throw { status: 404, message: 'El servicio seleccionado no existe' };
  }

  // Insertar reserva
  const query = `
    INSERT INTO bookings (client_name, client_email, service_id, booking_date, booking_time, status)
    VALUES (?, ?, ?, ?, ?, 'pending')
  `;
  const values = [client_name.trim(), client_email.trim(), service_id, booking_date.trim(), booking_time.trim()];

  const [result] = await pool.query(query, values);

  return {
    id: result.insertId,
    client_name: client_name.trim(),
    client_email: client_email.trim(),
    service_id,
    booking_date: booking_date.trim(),
    booking_time: booking_time.trim(),
    status: 'pending'
  };
};

module.exports = {
  getAllBookings,
  createBooking
};
