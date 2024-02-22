-- Insert data. 
TRUNCATE TABLE offer_bid_big;

INSERT INTO offer_bid_big(record, effective_date, offer_id, name, category, spec, base_price) 
VALUES ('offer','2024-02-18 12:15:05', 5, 'Intel CPU', 'CPU', 'Intel Core i5-12600K', '125.00');

INSERT INTO offer_bid_big(record, effective_date, offer_id, bid_id, bidder_id, bid_price) VALUES ('bid', '2024-02-19 08:29:55', 5, 15, 12, 130.00);

INSERT INTO offer_bid_big(record, effective_date, offer_id, bid_id, bidder_id, bid_price) VALUES ('bid', '2024-02-19 07:16:21', 5, 14, 99, 129.00);

INSERT INTO offer_bid_big(record, effective_date, offer_id, bid_id, bidder_id, bid_price) VALUES ('bid', '2024-02-20 01:15:01', 5, 16, 100, 137.00);

-- Select values. 
SELECT * from offer_bid_big;

-- Use a join to find the base, minimum, maximum bid...
-- plus the lucky winner. 
SELECT
    offer_id,
    anyIf(base_price, record = 'offer') AS starting_price,
    minIf(bid_price, record = 'bid') AS min,
    maxIf(bid_price, record = 'bid') AS max,
    argMax(bidder_id, bid_price) AS winner
FROM offer_bid_big
WHERE offer_id = 5
GROUP BY offer_id
