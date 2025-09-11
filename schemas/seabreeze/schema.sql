DROP DATABASE IF EXISTS seabreeze;

CREATE DATABASE seabreeze;

USE seabreeze;

DROP TABLE IF EXISTS `members`;

CREATE TABLE `members` (
    `id` INT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `mailaddress` TEXT NOT NULL COMMENT 'メールアドレス',
    `password` TEXT NOT NULL COMMENT 'パスワード',
    `fullname` TEXT COMMENT '氏名',
    `zipcode` TEXT COMMENT '郵便番号',
    `address` TEXT COMMENT '住所',
    `tel` TEXT COMMENT '電話番号',
    PRIMARY KEY (`id`)
) COMMENT = '会員マスタ';

DROP TABLE IF EXISTS `items`;

CREATE TABLE `items` (
    `id` INT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `item_no` TEXT NOT NULL COMMENT '商品番号',
    `item_name` TEXT NOT NULL COMMENT '商品名',
    `unit_price` INT NOT NULL COMMENT '単価',
    PRIMARY KEY (`id`)
) COMMENT = '商品マスタ';

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
    `id` INT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_no` VARCHAR(64) NOT NULL COMMENT '注文番号',
    `order_datetime` DATETIME NOT NULL COMMENT 'パスワード',
    `member_id` INT NOT NULL COMMENT '会員ID',
    `fullname` TEXT NOT NULL COMMENT '氏名',
    `zipcode` TEXT NOT NULL COMMENT '郵便番号',
    `address` TEXT NOT NULL COMMENT '住所',
    `tel` TEXT NOT NULL COMMENT '電話番号',
    `shipping` INT NOT NULL COMMENT '送料',
    `total` INT NOT NULL COMMENT '合計',
    PRIMARY KEY (`id`),
    UNIQUE KEY `order_no` (`order_no`),
    KEY `orders_FK1` (`member_id`),
    CONSTRAINT `orders_FK1` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) COMMENT = '注文テーブル';

DROP TABLE IF EXISTS `order_details`;

CREATE TABLE `order_details` (
    `id` INT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id` INT NOT NULL COMMENT '注文ID',
    `item_id` INT NOT NULL COMMENT '商品ID',
    `item_name` TEXT NOT NULL COMMENT '商品名',
    `unit_price` INT NOT NULL COMMENT '単価',
    `num` INT NOT NULL COMMENT '数量',
    `subtotal` INT NOT NULL COMMENT '小計',
    PRIMARY KEY (`id`),
    KEY `order_details_FK1` (`order_id`),
    KEY `order_details_FK2` (`item_id`),
    CONSTRAINT `order_details_FK1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
    CONSTRAINT `order_details_FK2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) COMMENT = '注文明細テーブル';