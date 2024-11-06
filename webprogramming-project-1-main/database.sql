create database if not exists `webpro`;
USE `webpro`;
SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `administrator` (
`admin_id` INT PRIMARY KEY,
`firstname` VARCHAR(50),
`lastname` VARCHAR(50),
`address` VARCHAR(100),
`age` INT,
`sex` VARCHAR(50),
`email` VARCHAR(100)
);

CREATE TABLE `admin_info` (
`admin_id` INT PRIMARY KEY,
`username` VARCHAR(50),
`password` VARCHAR(50),
`role` VARCHAR(20),
`login_log` VARCHAR(255)
);

CREATE TABLE `product_data` (
`product_id` INT PRIMARY KEY,
`product_name` VARCHAR(50),
`product_info` VARCHAR(255),
`product_price` DECIMAL(10,2)
);

INSERT INTO `administrator` VALUES
(177, 'Jedsada', 'Meenoi', 'Bangkok', 20, 'Male', 'captainmeenoi@gmail.com');

INSERT INTO `admin_info` VALUES
(177, 'Captain', '8964', 'Manager', 'Welcome back Manager'),
(178, 'test','1234','admin','welcome');

INSERT INTO `product_data` VALUES
(1, 'Costa Rican', 'Africa', '13.99'),
(2, 'Guatemalan', 'Africa', '13.99'),
(3, 'Nicaraguan', 'Africa', '13.99'),
(4, 'Signature', 'Thailand', '13.99'),
(5, 'Victorious', 'England', '13.99');
