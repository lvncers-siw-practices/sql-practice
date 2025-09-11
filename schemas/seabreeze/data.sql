
-- 商品マスタ
INSERT INTO items (item_no, item_name, unit_price)VALUES ('SB001', '海と白波', 2500);
INSERT INTO items (item_no, item_name, unit_price) VALUES ('SB002', '光の帽子雲', 3400);
INSERT INTO items (item_no, item_name, unit_price) VALUES ('SB003', '島の夕暮れ', 2900);
INSERT INTO items (item_no, item_name, unit_price) VALUES ('SB004', '海の奇岩', 2200);

-- 会員マスタ
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('sakura.yamamoto@example.com', '$$$passwordhash$$$', '山本 さくら', '123-4567', '東京都渋谷区神南1-2-3', '080-1234-5678');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('ichiro.suzuki@example.com', '$$$passwordhash$$$', '鈴木 一郎', '987-6543', '神奈川県横浜市中区山下町4-5-6', '090-2345-6080');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('aya.tanaka@example.com', '$$$passwordhash$$$', '田中 綾', '567-8901', '大阪府大阪市北区梅田2-3-4', '080-4567-8901');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('nana.nakamura@example.com', '$$$passwordhash$$$', '中村 那奈', '678-9012', '北海道札幌市中央区大通西8-9-10', '080-9012-3456');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('hanako.sato@example.com', '$$$passwordhash$$$', '佐藤 花子', '345-6789', '福岡県福岡市博多区博多駅前1-2-3', '090-2345-6789');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('kaori.ito@example.com', '$$$passwordhash$$$', '伊藤 香織', '890-1234', '兵庫県神戸市中央区三宮町4-5-6', '080-5678-9012');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('ayumi.watanabe@example.com', '$$$passwordhash$$$', '渡部 歩美', '901-2345', '広島県広島市中区八丁堀5-6-7', '080-1234-5678');
INSERT INTO members (mailaddress, password, fullname, zipcode, address, tel)
VALUES ('yusuke.yoshida@example.com', '$$$passwordhash$$$', '吉田 祐介', '567-8901', '滋賀県大津市浜大津1-2-3', '090-2345-5789');

-- 注文テーブル
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230622-0001', '2023-06-22 10:30:00', 2, '鈴木 一郎', '987-6543', '神奈川県横浜市中区山下町4-5-6', '090-2345-6080', 1000, 10300);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230622-0002', '2023-06-22 11:45:00', 3, '田中 綾', '567-8901', '大阪府大阪市北区梅田2-3-4', '090-2345-6789' ,800 ,3300);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230622-0003', '2023-06-22 13:15:00' ,6 ,'伊藤 香織', '890-1234', '兵庫県神戸市中央区三宮町4-5-6', '080-5678-9012', 1200, 5600);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230623-0001', '2023-06-23 14:20:00', 8, '吉田 祐介', '567-8901', '滋賀県大津市浜大津1-2-3', '090-2345-5789', 900, 18600);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230625-0001', '2023-06-25 15:40:00', 1, '山本 さくら', '123-4567', '東京都渋谷区神南1-2-3', '080-1234-5678', 1500, 27000);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230625-0002', '2023-06-25 16:55:00', 7, '渡部 歩美', '901-2345', '広島県広島市中区八丁堀5-6-7', '080-1234-5678' , 800, 3700);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230625-0003', '2023-06-25 17:30:00', 4, '中村 那奈', '678-9012', '北海道札幌市中央区大通西8-9-10', '080-9012-3456', 1100, 15000);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230625-0004', '2023-06-25 18:45:00', 1, '山本 さくら', '123-4567', '東京都渋谷区神南1-2-3' ,'080-1234-5678', 900, 10300);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230626-0001', '2023-06-26 19:15:00', 3, '田中 綾', '567-8901', '大阪府大阪市北区梅田2-3-4', '080-4567-8901', 800, 25900);
INSERT INTO orders (order_no, order_datetime, member_id, fullname, zipcode, address, tel, shipping, total)
VALUE ('230626-0002', '2023-06-26 20:30:00', 1, '山本 さくら', '123-4567', '東京都渋谷区神南1-2-3', '080-1234-5678', 1000, 24500);

-- 注文明細テーブル
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (1, 1, '海と白波', 2500, 1, 2500);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (1, 2, '光の帽子雲', 3400, 2, 6800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (2, 1, '海と白波', 2500, 1, 2500);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (3, 4, '海の奇岩', 2200, 2, 4400);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (4, 2, '光の帽子雲', 3400, 2, 6800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (4, 3, '島の夕暮れ', 2900, 3, 8700);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (4, 4, '海の奇岩', 2200, 1, 2200);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (5, 1, '海と白波', 2500, 4, 10000);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (5, 2, '光の帽子雲', 3400, 2, 6800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (5, 3, '島の夕暮れ', 2900, 3, 8700);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (6, 3, '島の夕暮れ', 2900, 1, 2900);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (7, 1, '海と白波', 2500, 1, 2500);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (7, 2, '光の帽子雲', 3400, 1, 3400);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (7, 3, '島の夕暮れ', 2900, 2, 5800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (7, 4, '海の奇岩', 2200, 1, 2200);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (8, 1, '海と白波', 2500, 2, 5000);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (8, 4, '海の奇岩', 2200, 2, 4400);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (9, 1, '海と白波', 2500, 1, 2500);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (9, 2, '光の帽子雲', 3400, 3, 10200);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (9, 3, '島の夕暮れ', 2900, 2, 5800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (9, 4, '海の奇岩', 2200, 3, 6600);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (10, 2, '光の帽子雲', 3400, 2, 6800);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (10, 3, '島の夕暮れ', 2900, 5, 14500);
INSERT INTO order_details (order_id, item_id, item_name, unit_price, num, subtotal)
VALUE (10, 4, '海の奇岩', 2200, 1, 2200);
