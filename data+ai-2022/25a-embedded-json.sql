-- Clear tables. 
DROP TABLE IF EXISTS readings_multi_json;

-- Readings table with multiple event types. 
CREATE TABLE IF NOT EXISTS readings_multi_json (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    sensor_type UInt8,
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    msg_type enum('reading'=1, 'restart'=2, 'err'=3),
    temperature Decimal(5,2) Codec(T64, LZ4),
    message String DEFAULT '',
    json String DEFAULT '' CODEC(ZSTD(1))
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (msg_type, sensor_id, time);

-- Drop index. 
ALTER TABLE readings_multi_json DROP INDEX jsonbf;
;

-- Add Bloom filter index. 
ALTER TABLE readings_multi_json
   ADD INDEX jsonbf json TYPE tokenbf_v1(32768, 3, 0) GRANULARITY 1
;

-- Materialize it. 
ALTER TABLE readings_multi_json
    MATERIALIZE INDEX jsonbf
;

-- Update table column to ZSTD(10). 
ALTER TABLE readings_multi_json
    MODIFY COLUMN `json` String DEFAULT '' CODEC(ZSTD(10))
;

ALTER TABLE readings_multi_json
    UPDATE json = json WHERE 1 = 1
;

-- Watch mutations. 
SELECT * FROM system.mutations WHERE NOT is_done;
