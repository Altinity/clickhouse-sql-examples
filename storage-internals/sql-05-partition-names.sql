-- Get ontime partitions names and IDs.
SELECT database, table, partition, partition_id, name
FROM system.parts WHERE database='default' AND table='ontime'
;
