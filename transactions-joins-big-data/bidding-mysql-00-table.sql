-- Bidding transaction tables in MySQL.
-- Simplefied model from https://vertabelo.com/blog/an-online-auction-data-model/. 
DROP TABLE IF EXISTS product;

DROP TABLE IF EXISTS bid;

DROP TABLE IF EXISTS category;

-- A product that is for auction. 
CREATE TABLE product (
    id BIGINT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(200)NOT NULL DEFAULT(UUID()),
    category_id INT NOT NULL,
    product_spec VARCHAR(2000) NOT NULL,
    base_price DECIMAL(15,2) NOT NULL,
    start_date DATETIME NOT NULL DEFAULT(NOW()),
    end_date DATETIME NOT NULL DEFAULT(NOW()),
    PRIMARY KEY (id)
);

-- A bid on the product. 
CREATE TABLE bid (
    id BIGINT NOT NULL AUTO_INCREMENT,
    bidder_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    bid_price DECIMAL(15,2) NOT NULL,
    bid_date DATETIME NOT NULL DEFAULT(NOW()),
    PRIMARY KEY (id)
);

-- A lookup table for product categories. 
CREATE TABLE category (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);
