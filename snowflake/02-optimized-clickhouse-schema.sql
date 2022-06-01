-- Run these commands in ClickHouse to optimize and reload data in 
-- a new table. 

-- Create table with optimized schema. 
CREATE TABLE IF NOT EXISTS ORDERS_OPTIMIZED (
  O_ORDERKEY UInt64,
  O_CUSTKEY UInt64,
  O_ORDERSTATUS FixedString(1),
  O_TOTALPRICE Decimal(12, 2) CODEC(ZSTD(10)),
  O_ORDERDATE Date,
  O_ORDERPRIORITY String,
  O_CLERK String CODEC(ZSTD(10)),
  O_SHIPPRIORITY UInt8,
  O_COMMENT String CODEC(ZSTD(10))
)
Engine=MergeTree()
PARTITION BY toYYYYMM(O_ORDERDATE)
ORDER BY (O_ORDERDATE, O_CUSTKEY)
;

-- Set to number of vCPUs.
SET max_insert_threads=2
;

-- Copy data from unoptimized table. 
INSERT INTO ORDERS_OPTIMIZED SELECT * FROM ORDERS
;

-- Merge excess partitions. 
OPTIMIZE TABLE ORDERS FINAL
;

-- Check table sizes. 
SELECT 
  name, total_rows AS rows,
  formatReadableSize(total_bytes) AS size
FROM system.tables 
WHERE name LIKE 'ORDERS%' ORDER BY name
;

-- Check column sizes.
SELECT table, name,
  formatReadableSize(sum(data_compressed_bytes)) AS tc,
  formatReadableSize(sum(data_uncompressed_bytes)) AS tu
FROM system.columns
WHERE table LIKE 'ORDERS%'
GROUP BY table, name ORDER BY name, table 
;

-- Select from each table. 
SELECT O_ORDERDATE AS date, uniq(O_CUSTKEY) AS unique_customers
FROM ORDERS 
WHERE date BETWEEN toDate('1993-12-01') AND toDate('1993-12-31')
GROUP BY date ORDER by date
;

SELECT O_ORDERDATE AS date, uniq(O_CUSTKEY) AS unique_customers
FROM ORDERS_OPTIMIZED
WHERE date BETWEEN toDate('1993-12-01') AND toDate('1993-12-31')
GROUP BY date ORDER by date
;
