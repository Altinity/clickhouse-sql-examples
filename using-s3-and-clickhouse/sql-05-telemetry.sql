-- S3 metrics.
SELECT * FROM system.metrics WHERE metric ILIKE '%s3%' ORDER BY metric;

-- File system cach metrics.
SELECT * FROM system.metrics WHERE metric ILIKE '%filesystemcache%' ORDER BY metric;
SELECT * FROM system.asynchronous_metrics WHERE metric ILIKE '%filesystemcache%' ORDER BY metric;

-- Selected event counters for S3. 
SELECT * FROM system.events WHERE event ILIKE '%s3%';
SELECT 
  sumIf(value, event = 'S3PutObject') as S3PutObject, 
  sumIf(value, event = 'S3GetObject') as S3GetObject, 
  sumIf(value, event = 'WriteBufferFromS3Bytes') as WriteBufferFromS3Bytes, 
  sumIf(value, event = 'ReadBufferFromS3Bytes') as ReadBufferFromS3Bytes
FROM system.events;

-- Sizes of our tables in storage.
SELECT table, count() AS parts, formatReadableSize(sum(bytes)) AS size
FROM system.parts WHERE database = 'default' AND active
GROUP BY table;

-- Size of the disk cache.
SELECT cache_name, formatReadableSize(sum(size)) AS size 
FROM system.filesystem_cache
WHERE cache_name = 's3_cache' GROUP BY cache_name;
