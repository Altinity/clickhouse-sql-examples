-- Clean up existing tables. 
DROP TABLE IF EXISTS readings_unopt;

DROP TABLE IF EXISTS readings_lz4;

DROP TABLE IF EXISTS readings_zstd;

-- Fully unoptimized table. 
CREATE TABLE IF NOT EXISTS readings_unopt (
    sensor_id Int64,
    sensor_type Int32,
    location String,
    time DateTime,
    date Date DEFAULT toDate(time),
    reading Float32
) Engine = MergeTree
PARTITION BY tuple()
ORDER BY tuple();

-- Partially optimized table with LZ4. 
CREATE TABLE IF NOT EXISTS readings_lz4 (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    sensor_type UInt16 Codec(LZ4),
    location LowCardinality(String) Codec(LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, LZ4)
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (location, sensor_id, time);

-- Optimized table with ZSTD. 
CREATE TABLE IF NOT EXISTS readings_zstd (
    sensor_id Int32 Codec(DoubleDelta, ZSTD(1)),
    sensor_type UInt16 Codec(ZSTD(1)),
    location LowCardinality(String) Codec(ZSTD(1)),
    time DateTime Codec(DoubleDelta, ZSTD(1)),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, ZSTD(10))
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (location, sensor_id, time);
