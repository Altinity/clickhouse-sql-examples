DROP TABLE IF EXISTS test_outliers_mv;
DROP TABLE IF EXISTS test_outliers;

-- Table with max/min temperatures. 
CREATE TABLE test_outliers (
    hour DateTime,
    min_temp SimpleAggregateFunction(min, Decimal(5,2)), 
    max_temp SimpleAggregateFunction(max, Decimal(5,2))
) ENGINE = AggregatingMergeTree
PARTITION BY toYYYYMM(hour)
ORDER BY hour;

-- MV to compute max/min temps by hour.
CREATE MATERIALIZED VIEW test_outliers_mv TO test_outliers
AS SELECT
    toStartOfHour(time) AS hour,
    min(temperature) AS min_temp,
    max(temperature) AS max_temp
FROM test GROUP BY hour

-- Table with actual outlier values. 
CREATE TABLE test_outliers_2 AS test
ENGINE = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (msg_type, sensor_id, time);

-- Capture any reading whose value is over 60. 
CREATE MATERIALIZED VIEW test_outliers_2_mv TO test_outliers_2
AS SELECT * FROM test WHERE temperature > 90.0;

-- Use URL engine to send a notification.
CREATE TABLE test_url_dispatch (
  sensor_id Int32,
  sensor_type UInt8,
  time DateTime,
  msg_type Enum8('reading' = 1, 'restart' = 2, 'err' = 3),
  temperature Decimal(5,2),
  message String
) ENGINE = URL('http://localhost:9999/', CSV)

-- Capture any reading whose value is over 60. 
CREATE MATERIALIZED VIEW test_url_dispatch_mv TO test_url_dispatch
AS SELECT * FROM test WHERE temperature > 90.0 Format CSV;


