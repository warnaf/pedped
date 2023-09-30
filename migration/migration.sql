CREATE DATABASE IF NOT EXISTS pedped;

CREATE TABLE IF NOT EXISTS `provinces` (
  `id` char(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `regencies` (
  `id` char(4) NOT NULL,
  `province_id` char(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `regencies_province_id_index` (`province_id`),
  CONSTRAINT `regencies_province_id_foreign` FOREIGN KEY (`province_id`) REFERENCES `provinces` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `districts` (
  `id` char(7) NOT NULL,
  `regency_id` char(4) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `districts_id_index` (`regency_id`),
  CONSTRAINT `districts_regency_id_foreign` FOREIGN KEY (`regency_id`) REFERENCES `regencies` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `villages` (
  `id` char(10) NOT NULL,
  `district_id` char(7) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `villages_district_id_index` (`district_id`),
  CONSTRAINT `villages_district_id_foreign` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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
  provinces_id CHAR(2) NOT NULL,
  regencies_id CHAR(4) NOT NULL,
  villages_id CHAR(7) NOT NULL,
  districts_id CHAR(10) NOT NULL,
  PRIMARY KEY (shop_id),
  UNIQUE KEY (owner_id),
  CONSTRAINT FK_ShopUser FOREIGN KEY (owner_id) REFERENCES users(user_id),
  CONSTRAINT FK_ShopProvince FOREIGN KEY (provinces_id) REFERENCES provinces(id),
  CONSTRAINT FK_ShopRegencie FOREIGN KEY (regencies_id) REFERENCES regencies(id),
  CONSTRAINT FK_ShopDistrict FOREIGN KEY (districts_id) REFERENCES districts(id),
  CONSTRAINT FK_ShopVillage FOREIGN KEY (villages_id) REFERENCES villages(id)
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
  shop_id BIGINT(20) UNSIGNED NOT NULL
  name VARCHAR(50) NOT NULL,
  description VARCHAR(200) NULL DEFAULT NULL,
  price BIGINT(20) NOT NULL DEFAULT 0,
  image_product TEXT NOT NULL DEFAULT 'default-product-image.png',
  variant_id BIGINT(20) UNSIGNED NULL DEFAULT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  CONSTRAINT FK_ProductShop FOREIGN KEY (shop_id) REFERENCES shops(shop_id),
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
  item_id BIGINT(20) UNSIGNED NOT NULL,
  item_name VARCHAR(50) NOT NULL,
  item_description VARCHAR(200) NULL DEFAULT NULL,
  item_price BIGINT(20) NOT NULL,
  item_image TEXT NOT NULL,
  item_shop_id BIGINT(20) UNSIGNED NOT NULL,
  qty INT(10) NOT NULL DEFAULT 1,
  order_id BIGINT(20) UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (snapshot_id),
  CONSTRAINT FK_OrderdetailProducts FOREIGN KEY (item_id) REFERENCES products(product_id),
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