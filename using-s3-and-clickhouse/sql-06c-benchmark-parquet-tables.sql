-- Test against Parquet on data lake with S3 table engine.
SELECT * FROM test_s3_table_parquet WHERE A = 443;
SELECT uniq(A) FROM test_s3_table_parquet;
SELECT count() FROM test_s3_table_parquet WHERE S LIKE '%4422%';

-- Repeat with s3 table function. 
SELECT * FROM 
s3('${EXT_AWS_S3_URL}datalake/test_s3_table_parquet', 'Parquet')
WHERE A = 443;

SELECT uniq(A) FROM 
s3('${EXT_AWS_S3_URL}datalake/test_s3_table_parquet', 'Parquet');

SELECT count() FROM 
s3('${EXT_AWS_S3_URL}datalake/test_s3_table_parquet', 'Parquet')
WHERE S LIKE '%4422%';

SELECT count() FROM 
s3Cluster('s3', '${EXT_AWS_S3_URL}datalake/test_s3_table_parquet', 'Parquet')
WHERE S LIKE '%4422%';
