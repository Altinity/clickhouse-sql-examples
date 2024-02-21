-- Bidding transaction tables in MySQL.
-- Simplefied model from https://vertabelo.com/blog/an-online-auction-data-model/. 
DROP TABLE IF EXISTS product;

DROP TABLE IF EXISTS bid;

DROP TABLE IF EXISTS category;

-- A product that is for auction. 
CREATE TABLE product (
    id Int64,
    product_name String,
    category_id Int32,
    product_spec String, 
    base_price Float32, 
    start_date DateTime,
    end_date DateTime
) 
Engine=ReplacingMergeTree
PARTITION BY toDate(start_date)
ORDER BY (category_id, id)
;

-- A bid on the product. 
CREATE TABLE bid (
    id Int64,
    bidder_id Int64,
    product_id Int64,
    bid_price Float32,
    bid_date DateTime,
    product_start_date DateTime
) 
Engine=ReplacingMergeTree
PARTITION BY toDate(product_start_date)
ORDER BY (category_id, bidder_id, id)
;

-- A lookup table for product categories. 
CREATE TABLE category (
    id Int32,
    name String
) 
Engine=MergeTree
ORDER BY tuple()
;
