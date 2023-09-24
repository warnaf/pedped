CREATE DATABASE IF NOT EXISTS pedped;

CREATE TABLE IF NOT EXISTS users(
  user_id BIGINT(20) UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL,
  birth_date DATE NOT NULL,
  email VARCHAR(50) NOT NULL,
  phone_number BIGINT(25) UNSIGNED NOT NULL,
  gender ENUM('male', 'female') NOT NULL,
  password VARCHAR(50) NULL DEFAULT NULL,
  pin INT(6) UNSIGNED NULL DEFAULT NULL,
  image_profile TEXT NOT NULL DEFAULT 'default-user-image.png',
  is_email_verified TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  is_phone_verified TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shops(
  shop_id BIGINT(20) UNSIGNED NOT NULL,
  owner_id BIGINT(20) UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(100) NULL DEFAULT NULL,
  image_shop TEXT NOT NULL DEFAULT 'default-shop-image.png',
  shop_type ENUM('PM', 'OM', 'M') NOT NULL DEFAULT 'M',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  operation_start TIME NOT NULL DEFAULT '07:00:00',
  operation_end TIME NOT NULL DEFAULT '17:00:00',
  balance DECIMAL(15,2) NOT NULL DEFAULT 0,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  alternative_url TEXT NOT NULL,
  provinces_id INT(2) NOT NULL,
  regencies_id INT(4) NOT NULL,
  villages_id INT(6) NOT NULL,
  districts_id INT(10) NOT NULL,
  PRIMARY KEY (shop_id),
  UNIQUE KEY (owner_id),
  CONSTRAINT FK_ShopUser FOREIGN KEY (owner_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS admin_shops(
  user_id BIGINT(20) UNSIGNED NOT NULL,
  shop_id BIGINT(20) UNSIGNED NOT NULL,
  CONSTRAINT FK_AdminshopUser FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT FK_AdminshopShop FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS variants(
  variant_id BIGINT(20) UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL,
  shop_id BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (variant_id),
  CONSTRAINT FK_VariantsShop FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS products(
  product_id BIGINT(20) UNSIGNED NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(200) NULL DEFAULT NULL,
  price BIGINT(20) NOT NULL DEFAULT 0,
  image_product TEXT NOT NULL DEFAULT 'default-product-image.png',
  variant_id BIGINT(20) UNSIGNED NULL DEFAULT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  CONSTRAINT FK_ProductVariant FOREIGN KEY (variant_id) REFERENCES variants(variant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS orders(
  order_id BIGINT(20) UNSIGNED NOT NULL,
  user_id BIGINT(20) UNSIGNED NOT NULL,
  payment_date DATETIME NULL DEFAULT NULL,
  finished_date DATETIME NULL DEFAULT NULL,
  status ENUM('waiting', 'process', 'delivery', 'done', 'complain') NOT NULL DEFAULT 'waiting',
  amount_total BIGINT(20) UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  CONSTRAINT FK_OrderUser FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS order_details(
  snapshot_id BIGINT(20) UNSIGNED NOT NULL,
  item_name VARCHAR(50) NOT NULL,
  item_description VARCHAR(200) NULL DEFAULT NULL,
  item_price BIGINT(20) NOT NULL,
  item_image TEXT NOT NULL,
  item_shop_id BIGINT(20) UNSIGNED NOT NULL,
  qty INT(10) NOT NULL DEFAULT 1,
  order_id BIGINT(20) UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (snapshot_id),
  CONSTRAINT FK_OrderdetailShop FOREIGN KEY (item_shop_id) REFERENCES shops(shop_id),
  CONSTRAINT FK_OrderdetailOrder FOREIGN KEY (order_id) REFERENCES orders(order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS sessions(
  user_id BIGINT(20) UNSIGNED NOT NULL,
  token TEXT NOT NULL,
  token_exp DATETIME NOT NULL,
  device_id TEXT NOT NULL,
  CONSTRAINT FK_SessionUser FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS shop_ratings(
  user_id BIGINT(20) UNSIGNED NOT NULL,
  stars DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  shop_id BIGINT(20) UNSIGNED NOT NULL,
  CONSTRAINT FK_ShopratingUser FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT FK_ShopratingShop FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;