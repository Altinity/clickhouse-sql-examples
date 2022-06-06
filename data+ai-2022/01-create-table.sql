-- Original schema from Alexander Zaitsev blog article. 
CREATE TABLE IF NOT EXISTS billy.readings (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    temperature Decimal(5,2) Codec(T64, LZ4)
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (sensor_id, time);

CREATE MATERIALIZED VIEW IF NOT EXISTS billy.readings_daily(
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
FROM billy.readings
GROUP BY sensor_id, date;
