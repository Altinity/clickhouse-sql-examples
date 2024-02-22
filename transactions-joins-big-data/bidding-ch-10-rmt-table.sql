-- Bidding transaction tables in MySQL.
-- Simplefied model from https://vertabelo.com/blog/an-online-auction-data-model/. 
DROP TABLE IF EXISTS offer_rmt;

DROP TABLE IF EXISTS bid_rmt;

DROP TABLE IF EXISTS category_rmt;

-- A offer that is for auction. 
CREATE TABLE offer_rmt (
    id Int64,
    effective_date DateTime,
    name String,
    category_id Int32,
    spec String, 
    base_price Float32, 
    start_date DateTime,
    end_date DateTime,
    is_deleted UInt8 DEFAULT 0
) 
Engine=ReplacingMergeTree(effective_date, is_deleted)
PARTITION BY toDate(start_date)
ORDER BY (category_id, id)
SETTINGS non_replicated_deduplication_window = 100;
;

-- A bid on the offer. 
CREATE TABLE bid_rmt (
    id Int64,
    effective_date DateTime, 
    bidder_id Int64,
    offer_id Int64,
    offer_effective_date DateTime,
    bid_price Float32,
    is_deleted UInt8 DEFAULT 0
) 
Engine=ReplacingMergeTree(effective_date, is_deleted)
PARTITION BY toDate(offer_effective_date)
ORDER BY (bidder_id, id)
SETTINGS non_replicated_deduplication_window = 100;
;

-- A lookup table for offer categories. 
CREATE TABLE category_rmt (
    id Int32,
    name String
) 
Engine=MergeTree
ORDER BY tuple()
;
