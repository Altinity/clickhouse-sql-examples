-- Bidding transaction tables in ClickHouse.
-- MergeTree engine with 100 block deduplication window.
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
Engine=MergeTree
PARTITION BY toDate(start_date)
ORDER BY (category_id, id, start_date)
SETTINGS non_replicated_deduplication_window = 100;
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
Engine=MergeTree
PARTITION BY toDate(product_start_date)
ORDER BY (bidder_id, product_start_date, id)
SETTINGS non_replicated_deduplication_window = 100;
;

-- A lookup table for product categories. 
CREATE TABLE category (
    id Int32,
    name String
) 
Engine=MergeTree
ORDER BY tuple()
SETTINGS non_replicated_deduplication_window = 100;
;
