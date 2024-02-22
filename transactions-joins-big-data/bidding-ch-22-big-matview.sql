-- Demonstrate a materialized view. 
DROP TABLE IF EXISTS bidding_view;

CREATE MATERIALIZED VIEW bidding_view 
Engine = AggregatingMergeTree() ORDER BY (offer_id)
POPULATE AS
SELECT
    offer_id,
    anyIf(base_price, record = 'offer') AS starting_price,
    minIf(bid_price, record = 'bid') AS min,
    maxIf(bid_price, record = 'bid') AS max,
    argMax(bidder_id, bid_price) AS winner
FROM offer_bid_big
GROUP BY offer_id
