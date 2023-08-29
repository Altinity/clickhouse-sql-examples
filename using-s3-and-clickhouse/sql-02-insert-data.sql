SET max_threads=8;
SET max_insert_threads=8; 

TRUNCATE TABLE test;
TRUNCATE TABLE test_s3_direct;
TRUNCATE TABLE test_s3_cached;
TRUNCATE TABLE test_s3_tiered;

-- Insert into regular table. 
INSERT INTO test SELECT number, number, '2023-01-01' FROM numbers(1e8);
INSERT INTO test_s3_direct select number, number, '2023-01-01' FROM numbers(1e8);
INSERT INTO test_s3_cached select number, number, '2023-01-01' FROM numbers(1e8);

-- Insert data by day into tiered table. 
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 9 DAY) FROM numbers(0 * 1e7 + 0, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 8 DAY) FROM numbers(1 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 7 DAY) FROM numbers(2 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 6 DAY) FROM numbers(3 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 5 DAY) FROM numbers(4 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 4 DAY) FROM numbers(5 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 3 DAY) FROM numbers(6 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 2 DAY) FROM numbers(7 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 1 DAY) FROM numbers(8 * 1e7 + 1, 1e7);
INSERT INTO test_s3_tiered select number, number, toDate(now() - INTERVAL 0 DAY) FROM numbers(9 * 1e7 + 1, 1e7);
