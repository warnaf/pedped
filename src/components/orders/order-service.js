import moment from 'moment';
import { validate } from '../../validation/validation.js';
import { camelCaseConvert, generateId, saveUpdate } from '../../app/utils.js';
import { ResponseError } from '../../error/response-error.js';
import { query, getConnectionPrimary } from '../../app/database.js';
import orderValidation from './order-validation.js';

const createOrder = async (reqBody) => {
  const inputCheck = validate(orderValidation.ordersValidation, reqBody);
  const idProduct = inputCheck.map((x) => x.id_product);
  const statementCheckGroupProduct = `SELECT product_id, name, description, price, image_product, shop_id FROM products WHERE product_id IN (${idProduct
    .map((x) => '?')
    .join()})`;
  const checkProductResult = await query(statementCheckGroupProduct, idProduct);
  // console.info(checkProductResult.length, inputCheck.length);
  // if (checkProductResult.length !== inputCheck.length) {
  //   const idProductNotExist = inputCheck.map((x) => {
  //     for (let index = 0; index < checkProductResult.length; index++) {
  //       if (x.id_product !== checkProductResult[index].product_id) {
  //         return x.id_product;
  //       }
  //     }
  //   });
  //   throw new ResponseError(400, idProductNotExist);
  // }

  const order_id = generateId();
  const user_id = 99999999;
  const status = 'done';
  let amount_total = 0;
  const created_at = moment().format('YYYY-MM-DD hh:mm:ss');
  const details = checkProductResult.map((element) => {
    const randomNumerForId = generateId();
    const container = {};
    let qty = 0;
    for (let index = 0; index < inputCheck.length; index++) {
      if (element.product_id === inputCheck[index].id_product) {
        qty = inputCheck[index].qty;
        amount_total = amount_total + qty * element.price;
      }
    }

    container.snapshot_id = randomNumerForId;
    container.item_id = element.product_id;
    container.item_name = element.name;
    container.item_description = element.description;
    container.item_price = element.price;
    container.item_image = element.image_product;
    container.item_shop_id = element.shop_id;
    container.qty = qty;
    container.order_id = order_id;
    container.created_at = created_at;
    return container;
  });
  const inserOrderDetailStatement =
    'INSERT INTO `order_details`(`snapshot_id`, `item_id`, `item_name`, `item_description`, `item_price`, `item_image`, `item_shop_id`, `qty`, `order_id`, `created_at`) VALUES (?,?,?,?,?,?,?,?,?,?)';
  const inserOrderStatement =
    'INSERT INTO `orders`(`order_id`, `user_id`, `payment_date`, `finished_date`, `status`, `amount_total`, `created_at`) VALUES (?,?,?,?,?,?,?)';

  try {
    const connection = await getConnectionPrimary();
    await connection.beginTransaction();
    await connection.query(inserOrderStatement, [
      order_id,
      user_id,
      created_at,
      created_at,
      status,
      amount_total,
      created_at,
    ]);
    details.forEach(async (element) => {
      await connection.query(inserOrderDetailStatement, [
        element.snapshot_id,
        element.item_id,
        element.item_name,
        element.item_description,
        element.item_price,
        element.item_image,
        element.item_shop_id,
        element.qty,
        element.order_id,
        element.created_at,
      ]);
    });
    await connection.commit();
    return idProduct;
  } catch (error) {
    await connection.rollback();
    throw new ResponseError(400, 'Database Error');
  }
};

export default { createOrder };
