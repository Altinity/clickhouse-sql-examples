-- Test against EBS. 
SELECT * FROM test WHERE A = 443 SETTINGS min_bytes_to_use_direct_io=1;
SELECT uniq(A) FROM test SETTINGS min_bytes_to_use_direct_io=1;
SELECT count() FROM test WHERE S LIKE '%4422%' SETTINGS min_bytes_to_use_direct_io=1;

-- Test against EBS. 
SELECT * FROM test WHERE A = 443;
SELECT uniq(A) FROM test;
SELECT count() FROM test WHERE S LIKE '%4422%';

-- Test against S3 direct. 
SELECT * FROM test_s3_direct WHERE A = 443;
SELECT uniq(A) FROM test_s3_direct;
SELECT count() FROM test_s3_direct WHERE S LIKE '%4422%';

-- Test against S3 cached with cache empty. 
SYSTEM DROP FILESYSTEM CACHE;
SELECT * FROM test_s3_cached WHERE A = 443;
SELECT uniq(A) FROM test_s3_cached;
SELECT count() FROM test_s3_cached WHERE S LIKE '%4422%';

-- Test against S3 cached with cache loaded. 
SELECT * FROM test_s3_cached WHERE A = 443;
SELECT uniq(A) FROM test_s3_cached;
SELECT count() FROM test_s3_cached WHERE S LIKE '%4422%';

-- Test against S3 tiered. 
SELECT * FROM test_s3_tiered WHERE A = 443;
SELECT uniq(A) FROM test_s3_tiered;
SELECT count() FROM test_s3_tiered WHERE S LIKE '%4422%';
