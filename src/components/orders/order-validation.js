import JoiBase from 'joi';
import JoiDate from '@joi/date';
const Joi = JoiBase.extend(JoiDate);

const orderObject = Joi.object({
  id_product: Joi.number().min(1).max(99999999).required().messages({
    'number.min': 'Masukan id product minimal 1 angka',
    'number.max': 'Masukan id product maximal 99999999 angka',
    'any.required': 'Masukan id product',
  }),
  qty: Joi.number().min(1).max(9999).required().messages({
    'number.min': 'Masukan qty minimal 1 angka',
    'number.max': 'Masukan qty maximal 99999999 angka',
    'any.required': 'Masukan qty',
  }),
});

const ordersValidation = Joi.array().items(orderObject);
export default { ordersValidation };
