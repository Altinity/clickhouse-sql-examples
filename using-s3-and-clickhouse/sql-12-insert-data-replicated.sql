SET max_threads=2;
SET max_insert_threads=2; 

TRUNCATE TABLE test;
TRUNCATE TABLE test_s3_direct;

-- Insert into regular table. 
INSERT INTO test SELECT number, number, '2023-01-01' FROM numbers(1e8);
INSERT INTO test_s3_direct select number, number, '2023-01-01' FROM numbers(1e8);
