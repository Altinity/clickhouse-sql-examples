-- Do the equivalent of the following update:
-- UPDATE bid SET bid_price=135.00 WHERE id = 15;
INSERT INTO bid_rmt(id, offer_id, bidder_id, bid_price, effective_date, offer_effective_date) VALUES
  (15, 5, 10, 135.00, '2024-02-20 10:55:17','2024-02-18 12:15:05');

-- Repeat without final. 
SELECT * from bid_rmt; 

-- Repeat with final. 
SELECT * from bid_rmt FINAL;

-- Repeat using setting instead of final. 
SELECT * from bid_rmt SETTINGS final = 1;
