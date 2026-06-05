const bookingService = require('../services/booking.service');

const getBookings = async (req, res) => {
  try {
    const bookings = await bookingService.getAllBookings();
    res.json(bookings);
  } catch (error) {
    console.error('Error in getBookings:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

const createBooking = async (req, res) => {
  try {
    const newBooking = await bookingService.createBooking(req.body);
    res.status(201).json({
      message: 'Reserva creada correctamente',
      booking: newBooking
    });
  } catch (error) {
    if (error.status) {
      return res.status(error.status).json({ message: error.message });
    }
    console.error('Error in createBooking:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

module.exports = {
  getBookings,
  createBooking
};
