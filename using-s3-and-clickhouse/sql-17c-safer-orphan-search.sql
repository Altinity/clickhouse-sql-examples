-- See README.md for example of how to run these queries. EXT_AWS_S3_URL
-- is an environmental variable that resolves to the S3 endpoint. 

-- Show the actual count of files under the S3 endpoint itself. 
SELECT count() AS files, sum(s3_size) as bytes
FROM s3_files
;

-- Use CTE to demonstrate that we can get data. 
WITH refs AS (
 SELECT s3_subpath, s3_refresh_datetime, s3_size, (ch_remote_path = '') as is_orphan, ch_remote_path, ch_size FROM
 (
   SELECT s3_size, s3_subpath, s3_refresh_datetime 
   FROM s3_files   
 ) AS s3
 LEFT OUTER JOIN
 (
   SELECT remote_path as ch_remote_path, size as ch_size
   FROM clusterAllReplicas('s3', system.remote_data_paths)
   WHERE disk_name = 's3_disk'
 ) ch
 ON s3_subpath = ch_remote_path
)
SELECT * FROM refs LIMIT 5 
FORMAT Vertical
;

-- Use CTE to look for orphans. 
WITH refs AS (
 SELECT s3_subpath, s3_refresh_datetime, s3_size, (ch_remote_path = '') as is_orphan, ch_remote_path, ch_size FROM
 (
   SELECT s3_size, s3_subpath, s3_refresh_datetime 
   FROM s3_files   
 ) AS s3
 LEFT OUTER JOIN
 (
   SELECT remote_path as ch_remote_path, size as ch_size
   FROM clusterAllReplicas('s3', system.remote_data_paths)
   WHERE disk_name = 's3_disk'
 ) ch
 ON s3_subpath = ch_remote_path
)
SELECT is_orphan, count(), sum(s3_size) FROM refs
WHERE s3_refresh_datetime < now() - INTERVAL 1 MINUTE
GROUP BY is_orphan
;

-- Use CTE to generate aws s3 rm commands. 
WITH refs AS (
 SELECT s3_subpath, s3_refresh_datetime, s3_size, (ch_remote_path = '') as is_orphan, ch_remote_path, ch_size FROM
 (
   SELECT s3_size, s3_subpath, s3_refresh_datetime 
   FROM s3_files   
 ) AS s3
 LEFT OUTER JOIN
 (
   SELECT remote_path as ch_remote_path, size as ch_size
   FROM clusterAllReplicas('s3', system.remote_data_paths)
   WHERE disk_name = 's3_disk'
 ) ch
 ON s3_subpath = ch_remote_path
)
SELECT 'aws s3 rm s3://mybucket/' || s3_subpath AS cmd FROM refs
WHERE is_orphan AND s3_refresh_datetime < now() - INTERVAL 1 MINUTE
ORDER BY cmd Format TSV
;
