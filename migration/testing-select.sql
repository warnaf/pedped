select 
  pds.product_id, 
  pds.name , 
  pds.description ,  
  pds.price, 
  pds.image_product , 
  COUNT(od.item_id) AS sold,
  ROUND(SUM(sr.stars)) AS shop_rating,
  sp.shop_id,  
  sp.name, 
  vlg.name
From products pds
Inner join shops sp ON pds.shop_id = sp.shop_id
Inner join order_details od ON pds.product_id = od.item_id
Inner join orders odr ON od.order_id = odr.order_id
INNER JOIN shop_ratings sr ON sr.shop_id = sp.shop_id
INNER JOIN districts vlg ON sp.villages_id = vlg.id
WHERE odr.status = 'done'
GROUP BY pds.product_id
ORDER BY shop_rating DESC;