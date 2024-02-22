-- Do the equivalent of the following DELETE:
-- DELETE FROM bid WHERE id = 15;
INSERT INTO bid_rmt(id, offer_id, bidder_id, bid_price, effective_date, offer_effective_date, is_deleted) VALUES
  (15, 5, 10, 135.00, '2024-02-20 12:55:17','2024-02-18 12:15:05', 1);

-- Repeat without final. 
SELECT * from bid_rmt; 

-- Repeat with final. 
SELECT * from bid_rmt FINAL;

-- Repeat using setting instead of final. 
SELECT * from bid_rmt SETTINGS final = 1;
