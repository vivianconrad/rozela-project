SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `Customer`, `manufacturer`, `Employee`, `order_contents`, `order_creation`, `printing_place`, `product`, `purchase_contents`, `purchase_creation`, `shipping`, `shopify`;
SET FOREIGN_KEY_CHECKS=1;
/* clears tables so that it doesnt just skip over edits */

CREATE TABLE IF NOT EXISTS  `Customer` (
  `customer_id` INT NOT NULL PRIMARY KEY,
  `line_item_id` INT NOT NULL,
  `first_name` VARCHAR(25) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `phone` VARCHAR(12) NULL,
  `email` VARCHAR(30) NULL,
  `shipping_street` VARCHAR(20) NOT NULL,
  `shipping_address_city` VARCHAR(10) NOT NULL,
  `shipping_address_zipcode` CHAR (10) NOT NULL,
  `shipping_address_state` CHAR(2) NOT NULL,
  `billing_info` VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS `Product` (
  `line_item_id` INT NOT NULL PRIMARY KEY,
  `design_id` VARCHAR(10) NOT NULL,
  `type_id` VARCHAR(10) NOT NULL,
  `product_size` VARCHAR(5) NULL,
  `product_color` VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS `order_contents` (
  `order_number` INT NOT NULL PRIMARY KEY,
  `line_item_id` INT NOT NULL,
  `payment_method` VARCHAR(15) NOT NULL,
  `discount_code` VARCHAR(5) NULL,
  `shopify_verified` BIT NOT NULL, #1 true, 0 false
  CONSTRAINT `order_fk1` FOREIGN KEY (`line_item_id`) REFERENCES `Product`(`line_item_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Employee` (
  `employee_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `first_name` VARCHAR(25) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `street` VARCHAR(30) NOT NULL,
  `city` VARCHAR(20) NOT NULL,
  `state` CHAR(2) NOT NULL,
  `zipcode` CHAR(10) NOT NULL,
  `hire_date` DATE NULL,
  `phone` VARCHAR(12) NULL,
  `email` VARCHAR(30) NULL,
  `order_number` INT NOT NULL,
  CONSTRAINT `employee_fk1` FOREIGN KEY (`order_number`) REFERENCES `order_contents`(`order_number`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `Shipping` (
  `order_number` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  `shipping_method` VARCHAR(20) NOT NULL,
  PRIMARY KEY(`order_number`, `customer_id`),
  CONSTRAINT `shipping_fk1` FOREIGN KEY (`order_number`) REFERENCES `order_contents`(`order_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `shipping_fk2` FOREIGN KEY (`customer_id`) REFERENCES `Customer`(`customer_id`) ON UPDATE CASCADE,
  CONSTRAINT `shipping_fk3` FOREIGN KEY (`employee_id`) REFERENCES `Employee`(`employee_id`) ON UPDATE CASCADE
);



CREATE TABLE IF NOT EXISTS `Printing_place` (
  `print_shop_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `shop_name` VARCHAR(10) NOT NULL,
  `location` VARCHAR(20) NOT NULL,
  `line_item_id` INT NOT NULL,
  `send_date_printing` DATE NULL,
  `recieve_date_printing` DATE NULL,
  `customer_id` INT NOT NULL,
  `employee_id` INT NOT NULL
  #CONSTRAINT `printing_place_fk2` FOREIGN KEY (`line_item_id`) REFERENCES `Product`(`line_item_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `manufacturer` (
  `manufacturer_id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `manufacturer_name` VARCHAR(10) NOT NULL,
  `location` VARCHAR(20) NOT NULL,
  `send_date_manufacturer` DATE NOT NULL,
  `recieve_date_manufacturer` DATE NULL,
  `order_number` INT NOT NULL,
  `line_item_id` INT NOT NULL,
  `employee_id` INT NOT NULL
  #CONSTRAINT `manufacturer_fk2` FOREIGN KEY (`line_item_id`) REFERENCES `Product`(`line_item_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `order_Creation` (
  `order_number` INT NOT NULL PRIMARY KEY,
  `manufacturer_id` INT NOT NULL,
  `send_date_manufacturer` DATE NOT NULL,
  `recieve_date_manufacturer` DATE NULL,
  `print_shop_id` INT NOT NULL,
  `send_date_printing` DATE NULL,
  `recieve_date_printing` DATE NULL,
  `details` TEXT NULL,
  CONSTRAINT `order_creation_fk1` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer`(`manufacturer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_creation_fk2` FOREIGN KEY (`print_shop_id`) REFERENCES `Printing_place`(`print_shop_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `order_Completion` (
  `order_number` INT NOT NULL PRIMARY KEY,
  `manufacturer_id` INT NOT NULL,
  `shipping_method` INT NOT NULL,
  `send_date_manufacturer` DATE NOT NULL,
  `recieve_date_manufacturer` DATE NULL,
  `print_shop_id` INT NOT NULL,
  `send_date_printing` DATE NULL,
  `recieve_date_printing` DATE NULL,
  `details` TEXT NULL,
  CONSTRAINT `order_creation_fk1` FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturer`(`manufacturer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_creation_fk2` FOREIGN KEY (`print_shop_id`) REFERENCES `Printing_place`(`print_shop_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE `Customer`
	ADD CONSTRAINT `customer_fk` FOREIGN KEY (`line_item_id`) REFERENCES `product`(`line_item_id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Manufacturer`
	ADD CONSTRAINT `manufacturer_fk` FOREIGN KEY (`manufacturer_id`) REFERENCES `order_creation`(`manufacturer_id`) ON DELETE CASCADE ON UPDATE CASCADE;
	
ALTER TABLE `Printing_place`
	ADD CONSTRAINT `printing_place_fk` FOREIGN KEY (`print_shop_id`) REFERENCES `order_creation`(`print_shop_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `Employee`
  ADD CONSTRAINT `employee_fk2` FOREIGN KEY (`order_number`) REFERENCES `order_creation`(`order_number`) ON DELETE CASCADE ON UPDATE CASCADE;
