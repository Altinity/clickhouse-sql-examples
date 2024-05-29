-- See README.md for example of how to run these queries. EXT_AWS_S3_URL
-- is an environmental variable that resolves to the S3 endpoint. 

-- Show amount of data each server thinks it is storing on a shared S3 endpoint. 
SELECT hostname() AS host, disk_name, path,
  count() AS files, sum(size) AS bytes
FROM clusterAllReplicas('s3', system.remote_data_paths)
WHERE disk_name = 's3_disk'
GROUP BY host, disk_name, path ORDER BY host, disk_name ASC, path ASC
;

-- Show the actual count of files under the S3 endpoint itself. 
SELECT count() AS files, sum(_size) as bytes
FROM s3('${EXT_AWS_S3_URL}/demo2/s3_disk/**', 'One')
;

-- Base query to compare data.
SELECT s3_subpath, s3_size, (ch_remote_path = '') as is_orphan, ch_remote_path, ch_size FROM
(
  SELECT _size as s3_size, regexpExtract(_path, '([a-zA-Z0-9\\-])/(.*)$', 2) AS s3_subpath
  FROM s3('${EXT_AWS_S3_URL}/demo2/s3_disk/**', 'One')
) AS s3
LEFT OUTER JOIN
(
  SELECT remote_path as ch_remote_path, size as ch_size
  FROM clusterAllReplicas('s3', system.remote_data_paths)
  WHERE disk_name = 's3_disk'
) ch
ON s3_subpath = ch_remote_path
ORDER BY s3_subpath LIMIT 10 
FORMAT Vertical
;

-- Run as CTE to demonstrate stats. 
WITH refs AS (
 SELECT s3_subpath, s3_size, (ch_remote_path = '') as is_orphan, ch_remote_path, ch_size FROM
 (
   SELECT _size as s3_size, regexpExtract(_path, '([a-zA-Z0-9\\-])/(.*)$', 2) AS s3_subpath
   FROM s3('${EXT_AWS_S3_URL}/demo2/s3_disk/**', 'One')
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
GROUP BY is_orphan
;
