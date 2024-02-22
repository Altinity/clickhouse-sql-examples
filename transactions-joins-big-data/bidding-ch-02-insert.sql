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

INSERT INTO bid(id, product_id, bidder_id, bid_price, bid_date, product_start_date) VALUES
  (14, 5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(15, 5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

-- Repeat, should be de-duped. 
INSERT INTO bid(id, product_id, bidder_id, bid_price, bid_date, product_start_date) VALUES
  (14, 5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(15, 5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

SELECT p.id, product_name, c.name, base_price, start_date, end_date, bidder_id, bid_price, bid_date
  FROM product p
    JOIN bid b ON p.id=b.product_id
    JOIN category c ON c.id=p.category_id FORMAT Vertical;
