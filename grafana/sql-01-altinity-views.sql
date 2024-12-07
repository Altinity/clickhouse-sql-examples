CREATE DATABASE IF NOT EXISTS altinity engine=Memory;


DROP VIEW IF EXISTS altinity.memory_usage;

CREATE VIEW altinity.memory_usage AS SELECT group, name, val, formatReadableSize(val) as readable_value FROM (

SELECT 'OS' as group, metric as name, toInt64(value) as val FROM system.asynchronous_metrics WHERE metric like 'OSMemory%'
UNION ALL
SELECT 'Caches' as group, metric as name, toInt64(value) FROM system.asynchronous_metrics WHERE metric LIKE '%CacheBytes'
UNION ALL
SELECT 'MMaps' as group, metric as name, toInt64(value) FROM system.metrics WHERE metric LIKE 'MMappedFileBytes'
UNION ALL
SELECT 'Process' as group, metric as name, toInt64(value) FROM system.asynchronous_metrics WHERE metric LIKE 'Memory%'
UNION ALL
SELECT 'MemoryTable', engine as name, toInt64(sum(total_bytes)) FROM system.tables WHERE engine IN ('Join','Memory','Buffer','Set') GROUP BY engine
UNION ALL
SELECT 'StorageBuffer' as group, metric as name, toInt64(value) FROM system.metrics WHERE metric='StorageBufferBytes'
UNION ALL
SELECT 'Queries' as group, left(query,7) as name, toInt64(sum(memory_usage)) FROM system.processes GROUP BY name
UNION ALL
SELECT 'Dictionaries' as group, type as name, toInt64(sum(bytes_allocated)) FROM system.dictionaries GROUP BY name
UNION ALL
SELECT 'PrimaryKeys' as group, 'db:'||database as name, toInt64(sum(primary_key_bytes_in_memory_allocated)) FROM system.parts GROUP BY name
UNION ALL
SELECT 'Merges' as group, 'db:'||database as name, toInt64(sum(memory_usage)) FROM system.merges GROUP BY name
UNION ALL
SELECT 'InMemoryParts' as group, 'db:'||database as name, toInt64(sum(data_uncompressed_bytes)) FROM system.parts WHERE part_type = 'InMemory' GROUP BY name
UNION ALL
SELECT 'AsyncInserts' as group, 'db:'||database as name, toInt64(sum(total_bytes)) FROM system.asynchronous_inserts GROUP BY name
/*UNION ALL
SELECT 'FileBuffersVirtual' as group, metric as name, toInt64(value * 2*1024*1024) FROM system.metrics WHERE metric like 'OpenFileFor%'
UNION ALL
SELECT 'ThreadStacksVirual' as group, metric as name, toInt64(value * 8*1024*1024) FROM system.metrics WHERE metric = 'GlobalThread'

 UNION ALL 
SELECT 'UserMemoryTracking' as group, user as name, toInt64(memory_usage) FROM system.user_processes */

/* UNION ALL - visible as QueryCacheBytes
select formatReadableSize(sum(result_size)) FROM system.query_cache;
*/ 

UNION ALL 
SELECT 'MemoryTracking' as group, 'total' as name, toInt64(value) FROM system.metrics WHERE metric = 'MemoryTracking'

)
ORDER BY group = 'OS', group = 'Process', val FORMAT PrettyCompactMonoBlock;


DROP TABLE IF EXISTS altinity.system_log_tables_size;

create view altinity.system_log_tables_size as select
    table,
    sum(rows),
    formatReadableSize(sum(bytes_on_disk)) as table_bytes_on_disk,
    min(min_date) as table_min_date,
    max(max_date) as table_max_date,
    min(partition_id) as min_partition_id
from system.parts
where database='system' and match(table,'_log(?:_\d+)?$')
group by database, table
with totals
ORDER BY sum(bytes_on_disk) DESC;


DROP TABLE IF EXISTS altinity.system_log_tables_size_with_partitions;

create view altinity.do_clean_system_log_tables as
SELECT 
    format( '{}; /* {} */', drop_statement, formatReadableSize(sum(freed_bytes)) ) as drop_statement_with_comment
FROM (
    WITH
        sum(partition_bytes_on_disk) as table_bytes_on_disk,
        max(partition_max_date) as table_max_date,
        groupArray( tuple(partition_id, partition_bytes_on_disk, partition_max_date) ) as partitions,
        if(
            table_max_date < {date:Date} and table_bytes_on_disk < 50000000000 /* default max_table_size_to_drop */,
            [tuple(format('DROP TABLE {}.{} SYNC', database, table), table_bytes_on_disk)],
            arrayMap(p -> tuple(format('ALTER TABLE {}.{} DROP PARTITION ID \'{}\'', database, table, p.1), p.2), arrayFilter( p -> p.3 < {date:Date}, partitions))
        ) as drop_statements, /* we can also respect max_partition_size_to_drop */
        arrayJoin(drop_statements) as drop_statement_tuple
    SELECT 
        drop_statement_tuple.1 as drop_statement,
        drop_statement_tuple.2 as freed_bytes
    from 
    (
        select
            database,
            table,
            partition_id,
            sum(rows) as partition_rows,
            sum(bytes_on_disk) as partition_bytes_on_disk,
            min(min_date) as partition_min_date,
            max(max_date) as partition_max_date
        from system.parts
        where
            database='system'
            and match(table,'_log(?:_\d+)?$')
        group
        by database, table, partition_id
    )
    group by database, table
) as drop_statements_with_freed_bytes
GROUP BY drop_statement
WITH TOTALS
ORDER BY sum(freed_bytes) DESC;

-- usage: select * from do_clean_system_log_tables(date = '2024-01-01') format TSVRaw;
