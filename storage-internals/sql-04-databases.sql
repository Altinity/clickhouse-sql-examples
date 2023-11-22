-- Show type and location of default database. 
SELECT name, engine, data_path, uuid FROM system.databases
WHERE name = 'default' FORMAT Vertical
;

-- Show type and location of system database. 
SELECT name, engine, data_path, uuid FROM system.databases
WHERE name = 'system' FORMAT Vertical
;

-- Show location of query log data and metadata. 
SELECT database, name, metadata_path, data_paths
FROM   system.tables
WHERE  database='system' and name like 'query_log' FORMAT Vertical
;

-- Show location of ontime data and metadata. 
SELECT database, name, metadata_path, data_paths
FROM   system.tables
WHERE  database='default' and name like 'ontime' FORMAT Vertical
;

-- Show location of parts. 
SELECT name, rows, bytes_on_disk, path
FROM system.parts WHERE database = 'default' AND table = 'ontime'
FORMAT Vertical
;
