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

