-- Insert data. 
TRUNCATE TABLE purchase;
TRUNCATE TABLE purchase_entry;

BEGIN;
INSERT INTO purchase(user_id) VALUES (5);
SET @last = LAST_INSERT_ID();
INSERT INTO purchase_entry(purchase_id, item_id, quantity, unit_price) VALUES
  (@last, 10, 1, 1.25), (@last, 11, 2, 5.99);
COMMIT;

SELECT uuid, user_id, created_at, item_id, quantity, unit_price, quantity * unit_price as total 
  FROM purchase p
    JOIN purchase_entry pe ON p.id=pe.purchase_id\G;
