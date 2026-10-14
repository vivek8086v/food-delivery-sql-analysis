-- MySQL 8.0+
CREATE DATABASE IF NOT EXISTS food_delivery_analytics;
USE food_delivery_analytics;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
 customer_id INT PRIMARY KEY, customer_name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE, city VARCHAR(60), signup_date DATE,
 customer_segment VARCHAR(20)
);
CREATE TABLE restaurants (
 restaurant_id INT PRIMARY KEY, restaurant_name VARCHAR(120) NOT NULL,
 city VARCHAR(60), cuisine VARCHAR(40), rating DECIMAL(2,1),
 is_active TINYINT NOT NULL DEFAULT 1, CHECK (rating BETWEEN 0 AND 5)
);
CREATE TABLE products (
 product_id INT PRIMARY KEY, restaurant_id INT NOT NULL, product_name VARCHAR(120) NOT NULL,
 category VARCHAR(40), price DECIMAL(10,2) NOT NULL, is_available TINYINT NOT NULL DEFAULT 1,
 CONSTRAINT fk_products_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
 CHECK (price >= 0)
);
CREATE TABLE orders (
 order_id INT PRIMARY KEY, customer_id INT NOT NULL, restaurant_id INT NOT NULL,
 order_datetime DATETIME NOT NULL, order_status VARCHAR(20) NOT NULL,
 delivery_minutes INT NULL, delivery_fee DECIMAL(8,2) NOT NULL DEFAULT 0,
 discount_amount DECIMAL(8,2) NOT NULL DEFAULT 0, payment_method VARCHAR(20),
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
 FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
 CHECK (delivery_fee >= 0), CHECK (discount_amount >= 0)
);
CREATE TABLE order_items (
 order_item_id INT PRIMARY KEY, order_id INT NOT NULL, product_id INT NOT NULL,
 quantity INT NOT NULL, unit_price DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (order_id) REFERENCES orders(order_id),
 FOREIGN KEY (product_id) REFERENCES products(product_id),
 CHECK (quantity > 0), CHECK (unit_price >= 0)
);
CREATE INDEX idx_orders_date_status ON orders(order_datetime, order_status);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_products_restaurant ON products(restaurant_id);
