const serviceService = require('../services/service.service');

const getServices = async (req, res) => {
  try {
    const services = await serviceService.getAllServices();
    res.json(services);
  } catch (error) {
    console.error('Error in getServices:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

const createService = async (req, res) => {
  try {
    const newService = await serviceService.createService(req.body);
    res.status(201).json({
      message: 'Servicio creado correctamente',
      service: newService
    });
  } catch (error) {
    if (error.status) {
      return res.status(error.status).json({ message: error.message });
    }
    console.error('Error in createService:', error);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
};

module.exports = {
  getServices,
  createService
};
