-- Run these commands in ClickHouse to load Parquet data from Snowflake.

-- This table is for loading only and should be optimized after loading.
CREATE TABLE IF NOT EXISTS ORDERS (
  O_ORDERKEY Int128,
  O_CUSTKEY Int128,
  O_ORDERSTATUS String,
  O_TOTALPRICE Decimal(12, 2),
  O_ORDERDATE Date,
  O_ORDERPRIORITY String,
  O_CLERK String,
  O_SHIPPRIORITY Int128,
O_COMMENT String
)
Engine=MergeTree()
PARTITION BY tuple()
ORDER BY tuple()
;

-- INSERT command to load S3 data. 
INSERT INTO ORDERS
SELECT * FROM s3('https://s3.us-east-1.amazonaws.com/your-migration-bucket/snowflake/SNOWFLAKE_SAMPLE_DATA/TPCH_SF100/ORDERS/*.parquet', 
'aws_access_key', 'aws_secret_key', Parquet,
'O_ORDERKEY Int128, O_CUSTKEY Int128, O_ORDERSTATUS String, O_TOTALPRICE Decimal(12, 2), O_ORDERDATE Date, O_ORDERPRIORITY String, O_CLERK String, O_SHIPPRIORITY Int128, O_COMMENT String')
;

-- Confirm that all rows loaded. 
SELECT count() FROM ORDERS
;
