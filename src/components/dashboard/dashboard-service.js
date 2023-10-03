import { query, redisGet, redisSet } from '../../app/database.js';

const recomendation = async () => {
  const recomendationStatement = `select 
  pds.product_id AS id_product, 
  pds.name AS product_name, 
  pds.description AS product_description,  
  pds.price AS product_price, 
  pds.image_product AS product_image, 
  COUNT(od.item_id) AS product_sold,
  ROUND(SUM(sr.stars)) AS shop_rating,
  sp.shop_id AS id_shop,  
  sp.name AS shop_name, 
  vlg.name AS shop_village
  From products pds
  Inner join shops sp ON pds.shop_id = sp.shop_id
  Inner join order_details od ON pds.product_id = od.item_id
  Inner join orders odr ON od.order_id = odr.order_id
  INNER JOIN shop_ratings sr ON sr.shop_id = sp.shop_id
  INNER JOIN districts vlg ON sp.villages_id = vlg.id
  WHERE odr.status = 'done'
  GROUP BY pds.product_id
  ORDER BY shop_rating DESC`;
  const recomendationResult = await query(recomendationStatement);
  return {
    isFromRedis: false,
    value: recomendationResult,
  };
};

const recomendationWithRedis = async () => {
  const redisKey = 'Recomendation';
  const recomendationStatement = `select 
    pds.name AS product_name, 
    pds.product_id AS id_product, 
    pds.price AS product_price, 
    pds.description AS product_description,  
    COUNT(od.item_id) AS product_sold,
    pds.image_product AS product_image, 
    ROUND(SUM(sr.stars)) AS shop_rating,
    sp.shop_id AS id_shop,  
    sp.name AS shop_name, 
    vlg.name AS shop_village
    From products pds
    Inner join shops sp ON pds.shop_id = sp.shop_id
    Inner join order_details od ON pds.product_id = od.item_id
    Inner join orders odr ON od.order_id = odr.order_id
    INNER JOIN shop_ratings sr ON sr.shop_id = sp.shop_id
    INNER JOIN districts vlg ON sp.villages_id = vlg.id
    WHERE odr.status = 'done'
    GROUP BY pds.product_id
    ORDER BY shop_rating DESC`;
  const checkDataInRedis = redisGet(redisKey);
  if (checkDataInRedis === null) {
    const recomendationResult = await query(recomendationStatement);
    await redisSet(redisKey, recomendationResult);
    return {
      isFromRedis: false,
      value: recomendationResult,
    };
  }
  return {
    isFromRedis: true,
    value: checkDataInRedis,
  };
};

export default { recomendation, recomendationWithRedis };
