-- Get stats from system tables.
SELECT name, type, path, free_space, total_space FROM system.disks;
SELECT * FROM system.storage_policies;

-- Get table sizes by part. 
SELECT table, disk_name, partition, sum(rows),
    formatReadableSize(sum(bytes_on_disk)) AS size,
    count() AS part_count
FROM system.parts WHERE (database = 'default') AND active
GROUP BY table, disk_name, partition 
ORDER BY table, disk_name, partition;

-- Get size of parts on s3 disk. 
SELECT disk_name, formatReadableSize(sum(bytes_on_disk))
FROM system.parts GROUP BY disk_name ORDER BY disk_name;

-- Get amount of storage currently managed in s3. 
SELECT formatReadableSize(sum(size))
FROM system.remote_data_paths;
