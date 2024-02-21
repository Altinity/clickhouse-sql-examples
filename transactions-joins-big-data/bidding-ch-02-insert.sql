-- Insert data. 
TRUNCATE TABLE bid;
TRUNCATE TABLE product;
TRUNCATE TABLE category;

INSERT INTO category(id, name) values (1, 'motherboard');
INSERT INTO category(id, name) values (2, 'cpu');
INSERT INTO category(id, name) values (3, 'storage');
INSERT INTO category(id, name) values (4, 'power supply');
INSERT INTO category(id, name) values (5, 'ram');

INSERT INTO product(id, product_name, category_id, product_spec, base_price, start_date, end_date)
  VALUES (5, 'Intel CPU', 2, 'Intel Core i5-12600K', '125.00', '2024-02-18 12:15:05', '2024-02-25 12:00:05');

INSERT INTO bid(product_id, bidder_id, bid_price, bid_date, product_start_date) VALUES
  (5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

-- Repeat, should be de-duped. 
INSERT INTO bid(product_id, bidder_id, bid_price, bid_date, product_start_date) VALUES
  (5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

SELECT p.id, product_name, pc.name, base_price, start_date, end_date, bidder_id, bid_price, bid_date
  FROM product p
    JOIN bid pb ON p.id=pb.product_id
    JOIN category pc ON pc.id=p.category_id FORMAT Vertical;
