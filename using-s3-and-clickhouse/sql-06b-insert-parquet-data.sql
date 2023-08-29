SET max_threads=8;
SET max_insert_threads=8; 

-- Insert into regular table. 
INSERT INTO test_s3_table_parquet SELECT number, number, '2023-01-01' FROM numbers(1e8);
