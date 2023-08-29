-- Get stats from system tables.
SELECT name, type, path, free_space, total_space FROM system.disks;
SELECT * FROM system.storage_policies;

-- Get tables sizes. 
SELECT disk_name, partition, sum(rows),
    formatReadableSize(sum(bytes_on_disk)) AS size,
    count() AS part_count
FROM system.parts WHERE (table = 'test') AND active
GROUP BY disk_name, partition;

SELECT disk_name, partition, sum(rows),
    formatReadableSize(sum(bytes_on_disk)) AS size,
    count() AS part_count
FROM system.parts WHERE (table = 'test_s3_direct') AND active
GROUP BY disk_name, partition;

SELECT disk_name, partition, sum(rows),
    formatReadableSize(sum(bytes_on_disk)) AS size,
    count() AS part_count
FROM system.parts WHERE (table = 'test_s3_cached') AND active
GROUP BY disk_name, partition;
