-- Unoptimized table. 
CREATE TABLE IF NOT EXISTS readings (
    sensor_id Int32,
    sensor_type String,
    location String,
    time DateTime,
    date ALIAS toDate(time),
    reading Float32
) Engine = MergeTree
PARTITION BY toDate(time)
ORDER BY (location, sensor_id, time);

-- Optimized table with LZ4. 
CREATE TABLE IF NOT EXISTS readings_optimized_lz4 (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    sensor_type LowCardinality(String) Codec(LZ4),
    location LowCardinality(String) Codec(LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, LZ4)
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (location, sensor_id, time);

-- Optimized table with ZSTD. 
CREATE TABLE IF NOT EXISTS readings_optimized_zstd (
    sensor_id Int32 Codec(DoubleDelta, ZSTD(1)),
    sensor_type LowCardinality(String) Codec(ZSTD(1)),
    location LowCardinality(String) Codec(ZSTD(1)),
    time DateTime Codec(DoubleDelta, ZSTD(1)),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, ZSTD(1))
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (location, sensor_id, time);
