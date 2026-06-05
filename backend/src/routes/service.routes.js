const { Router } = require('express');
const { getServices, createService } = require('../controllers/service.controller');

const router = Router();

router.get('/', getServices);
router.post('/', createService);

module.exports = router;
