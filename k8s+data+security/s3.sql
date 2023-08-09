-- Sample SQL to test S3 table engine. 
CREATE TABLE s3_engine_table (name String, value UInt32)
    ENGINE=S3('https://rhodges-us-west-2-playground-1.s3.amazonaws.com/k8s/security/s3_engine_table/test-data.csv.gz', 'CSV', 'gzip')
    SETTINGS input_format_with_names_use_header = 0;

INSERT INTO s3_engine_table VALUES ('one', 1), ('two', 2), ('three', 3);

SELECT * FROM s3_engine_table LIMIT 2;
