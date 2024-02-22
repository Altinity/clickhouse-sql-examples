-- Bidding transaction tables in MySQL.
-- Simplefied model from https://vertabelo.com/blog/an-online-auction-data-model/. 
DROP TABLE IF EXISTS offer_bid_big;

-- A single big table for all values. 
CREATE TABLE offer_bid_big (
    record enum('offer'=1, 'bid'=2), 
    effective_date DateTime,
    -- Product offer values.
    offer_id Int64,
    name String,
    category String,
    spec String, 
    base_price Float32, 
    -- Product bid values.
    bid_id Int64,
    bidder_id Int64, 
    bid_price Float32,
) 
Engine=MergeTree
PARTITION BY toDate(effective_date)
PRIMARY KEY (category, name, offer_id)
ORDER BY (category, name, offer_id, effective_date)
SETTINGS non_replicated_deduplication_window = 100;
