const { pool } = require('../config/db');

const getAllServices = async () => {
  const [rows] = await pool.query('SELECT * FROM services ORDER BY id DESC');
  return rows;
};

const createService = async (serviceData) => {
  let { name, description, price, duration } = serviceData;

  // Validación de name
  if (!name || typeof name !== 'string' || name.trim() === '') {
    throw { status: 400, message: 'El nombre del servicio es obligatorio' };
  }

  // Validación de description
  if (!description) {
    description = '';
  }

  // Validación de price
  if (price === undefined || price === null || isNaN(price) || Number(price) < 0) {
    throw { status: 400, message: 'El precio debe ser un número mayor o igual a 0' };
  }

  // Validación de duration
  if (duration === undefined || duration === null || isNaN(duration) || Number(duration) <= 0) {
    throw { status: 400, message: 'La duración debe ser un número mayor a 0' };
  }

  const query = 'INSERT INTO services (name, description, price, duration) VALUES (?, ?, ?, ?)';
  const values = [name.trim(), description.trim(), Number(price), Number(duration)];

  const [result] = await pool.query(query, values);

  return {
    id: result.insertId,
    name: name.trim(),
    description: description.trim(),
    price: Number(price),
    duration: Number(duration)
  };
};

module.exports = {
  getAllServices,
  createService
};
