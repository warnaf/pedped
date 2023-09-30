import express from 'express';
import {
  getRecomendationProduct,
  getRecomendationProductRedis,
} from './dashboard-controller.js';

const router = new express.Router();
router.get('/with/database', getRecomendationProduct);
router.get('/with/redis', getRecomendationProductRedis);

export default { router };
