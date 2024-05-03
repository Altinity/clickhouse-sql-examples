-- Test against EBS. 
SELECT * FROM test WHERE A = 443 SETTINGS min_bytes_to_use_direct_io=1;
SELECT uniq(A) FROM test SETTINGS min_bytes_to_use_direct_io=1;
SELECT count() FROM test WHERE S LIKE '%4422%' SETTINGS min_bytes_to_use_direct_io=1;

-- Test against EBS. 
SELECT * FROM test WHERE A = 443;
SELECT uniq(A) FROM test;
SELECT count() FROM test WHERE S LIKE '%4422%';

-- Test against S3 disk. 
SELECT * FROM test_s3_disk WHERE A = 443;
SELECT uniq(A) FROM test_s3_disk;
SELECT count() FROM test_s3_disk WHERE S LIKE '%4422%';

-- Test against S3 disk with zero copy replication.
SELECT * FROM test_s3_zero_copy WHERE A = 443;
SELECT uniq(A) FROM test_s3_zero_copy;
SELECT count() FROM test_s3_zero_copy WHERE S LIKE '%4422%';
