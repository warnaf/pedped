import orderService from './order-service.js';
const createOrder = async (req, res, next) => {
  try {
    const reqBody = req.body;
    const result = await orderService.createOrder(reqBody);
    res.status(200).json({
      data: result,
    });
  } catch (error) {
    next(error);
  }
};
const getOrder = async (req, res, next) => {};
const singleOrder = async (req, res, next) => {};
const getDetailOrder = async (req, res, next) => {};
const updateStatusOrder = async (req, res, next) => {};

export {
  createOrder,
  getOrder,
  singleOrder,
  getDetailOrder,
  updateStatusOrder,
};
