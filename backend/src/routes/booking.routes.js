const { Router } = require('express');
const { getBookings, createBooking } = require('../controllers/booking.controller');

const router = Router();

router.get('/', getBookings);
router.post('/', createBooking);

module.exports = router;
