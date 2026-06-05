const { Router } = require('express');

const router = Router();

router.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'Buki Booking API funcionando correctamente'
  });
});

module.exports = router;
