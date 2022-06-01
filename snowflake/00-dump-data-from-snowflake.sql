-- Run these commands in Snowflake to dump data to S3. 

-- Create a schema to put objects in.
CREATE SCHEMA S3

-- Create a stage connected to an S3 bucket that can write Parquet.
CREATE OR REPLACE STAGE S3.BUCKET
URL='s3://your-migration-bucket/snowflake'
CREDENTIALS=
  (aws_key_id='aws_access_key',aws_secret_key='aws_secret_key')
FILE_FORMAT = (TYPE = PARQUET);

-- Write data into Parquet files on S3.
COPY INTO @S3.BUCKET/SNOWFLAKE_SAMPLE_DATA/TPCH_SF100/ORDERS/ 
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS
HEADER=TRUE

-- Select count of rows in Parquet files. 
SELECT COUNT(*) 
FROM @S3.BUCKET/SNOWFLAKE_SAMPLE_DATA/TPCH_SF100/ORDERS/

-- Select count of rows in the source table. (Should be the same.)
SELECT COUNT(*) 
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS
