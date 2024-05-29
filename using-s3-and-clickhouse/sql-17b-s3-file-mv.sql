-- See README.md for example of how to run these queries. EXT_AWS_S3_URL
-- is an environmental variable must resolve to the S3 endpoint. 

DROP TABLE IF EXISTS s3_files;
DROP TABLE IF EXISTS s3_files_mv;

-- Create target table. 
CREATE TABLE s3_files (
  s3_file String, 
  s3_size UInt64,
  s3_subpath String, 
  s3_refresh_datetime DateTime DEFAULT now()
)
ENGINE=MergeTree
PARTITION BY tuple()
ORDER BY s3_subpath;

-- Must set allow_experimental_refreshable_materialized_view = 1
-- This can be done in the profile. Note also that this feature 
-- requires both server and clickhouse-client are at version 23.12
-- or higher.
CREATE MATERIALIZED VIEW s3_files_mv
REFRESH EVERY 1 HOUR TO s3_files 
AS 
  SELECT 
    _file as s3_file,
    _size as s3_size, 
    regexpExtract(_path, '([a-zA-Z0-9\\-])/(.*)$', 2) AS s3_subpath,
    now() as s3_refresh_datetime
  FROM s3('${EXT_AWS_S3_URL}/demo2/s3_disk/**', 'One')
;

-- Refresh the view contents immediately. 
SYSTEM REFRESH VIEW s3_files_mv
;
