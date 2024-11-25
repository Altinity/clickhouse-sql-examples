-- A test table that we can use for examples.
CREATE TABLE test
(
    `sensor_id` Int32 CODEC(DoubleDelta, LZ4),
    `sensor_type` UInt8,
    `time` DateTime CODEC(DoubleDelta, LZ4),
    `date` Date ALIAS toDate(time),
    `msg_type` Enum8('reading' = 1, 'restart' = 2, 'err' = 3),
    `temperature` Decimal(5, 2) CODEC(T64, LZ4),
    `message` String DEFAULT ''
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (msg_type, sensor_id, time)
