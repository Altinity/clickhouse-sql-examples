-- Transaction table in MySQL.
DROP TABLE IF EXISTS purchase;

DROP TABLE IF EXISTS purchase_entry;

DROP TABLE IF EXISTS purchase_order;

CREATE TABLE purchase (
    id BIGINT NOT NULL AUTO_INCREMENT,
    uuid VARCHAR(36)  NOT NULL DEFAULT(UUID()),
    user_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT(NOW()),
    PRIMARY KEY (id)
);

CREATE TABLE purchase_entry (
    id BIGINT NOT NULL AUTO_INCREMENT,
    purchase_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE purchase_order (
    id BIGINT NOT NULL AUTO_INCREMENT,
    purchase_id BIGINT NOT NULL,
    dest_address VARCHAR(500) NOT NULL,
    shipping_tag VARCHAR(50) NOT NULL,
    subtotal DECIMAL(15,2) NOT NULL,
    tax DECIMAL(15,2) NOT NULL,
    total DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id)
);
