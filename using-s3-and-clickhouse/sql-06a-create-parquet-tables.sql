DROP TABLE IF EXISTS test_s3_table_parquet;

CREATE TABLE test_s3_table_parquet
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = S3('${EXT_AWS_S3_URL}/datalake/test_s3_table_parquet', 'Parquet')
PARTITION BY D
