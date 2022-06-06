-- Clear tables. 
DROP TABLE IF EXISTS readings_multi;
DROP TABLE IF EXISTS readings_multi_daily;
DROP TABLE IF EXISTS sensor_types;

-- Readings table with multiple event types. 
CREATE TABLE IF NOT EXISTS readings_multi (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    sensor_type UInt8,
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    msg_type enum('reading'=1, 'restart'=2, 'err'=3),
    temperature Decimal(5,2) Codec(T64, LZ4),
    message String DEFAULT ''
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (msg_type, sensor_id, time);

CREATE MATERIALIZED VIEW IF NOT EXISTS readings_multi_daily (
  sensor_id Int32 Codec(DoubleDelta, LZ4),
  date Date Codec(DoubleDelta, LZ4),
  temp_min SimpleAggregateFunction(min, Decimal(5,2)),
  temp_max SimpleAggregateFunction(max, Decimal(5,2))
) Engine = AggregatingMergeTree
PARTITION BY toYYYYMM(date)
ORDER BY (sensor_id, date)
AS
SELECT sensor_id, date,
   min(temperature) as temp_min,
   max(temperature) as temp_max
FROM readings_multi
WHERE msg_type = 'reading'
GROUP BY sensor_id, date;

CREATE TABLE IF NOT EXISTS sensor_types (
    type UInt8,
    name String,
    description String
) Engine = MergeTree
PARTITION BY tuple()
ORDER BY tuple();
