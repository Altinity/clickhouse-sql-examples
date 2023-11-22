-- Count rows in the table. 
SELECT count() from ontime
;

-- Show current parts.
SELECT name, active, level, rows, bytes_on_disk
FROM system.parts WHERE database = 'default' AND table = 'ontime'
;

-- Show count of parts. 
SELECT count()
FROM system.parts WHERE database = 'default' AND table = 'ontime'
;
