import express from 'express';
import { createOrder } from './order-controller.js';

const router = new express.Router();
router.post('/', createOrder);

export default { router };
