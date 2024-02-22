-- Insert data. 
TRUNCATE TABLE bid_rmt;
TRUNCATE TABLE offer_rmt;
TRUNCATE TABLE category_rmt;

INSERT INTO category_rmt(id, name) values (1, 'motherboard');
INSERT INTO category_rmt(id, name) values (2, 'cpu');
INSERT INTO category_rmt(id, name) values (3, 'storage');
INSERT INTO category_rmt(id, name) values (4, 'power supply');
INSERT INTO category_rmt(id, name) values (5, 'ram');

INSERT INTO offer_rmt(id, name, category_id, spec, base_price, start_date, end_date)
  VALUES (5, 'Intel CPU', 2, 'Intel Core i5-12600K', '125.00', '2024-02-18 12:15:05', '2024-02-25 12:00:05');

INSERT INTO bid_rmt(id, offer_id, bidder_id, bid_price, effective_date, offer_effective_date) VALUES
  (14, 5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(15, 5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

-- Repeat, should be de-duped. 
INSERT INTO bid_rmt(id, offer_id, bidder_id, bid_price, effective_date, offer_effective_date) VALUES
  (14, 5, 12, 130.00, '2024-02-19 08:29:55','2024-02-18 12:15:05'),(15, 5, 10, 127.00, '2024-02-19 09:01:17','2024-02-18 12:15:05');

SELECT o.id, o.name, c.name, base_price, start_date, end_date, bidder_id, bid_price, b.effective_date
  FROM offer_rmt o
    JOIN bid_rmt b ON o.id=b.offer_id
    JOIN category_rmt c ON c.id=o.category_id FORMAT Vertical;

SELECT o.id, 
       any(base_price), 
       min(b.bid_price) as min, 
       max(b.bid_price) as max
  FROM offer_rmt o 
    JOIN bid_rmt b ON o.id=b.offer_id
      WHERE o.id = 5
        GROUP BY o.id
