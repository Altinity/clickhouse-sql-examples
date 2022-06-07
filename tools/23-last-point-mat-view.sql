-- Example query to find latest restart time for a group of devices. 
SELECT sensor_id, time as restart_time, msg_type FROM
(
  SELECT sensor_id, time, msg_type
  FROM readings_multi
  WHERE msg_type = 'restart'
    AND (sensor_id, time) IN
      (SELECT sensor_id, max(time)
       FROM readings_multi
       GROUP BY sensor_id)
)
ORDER BY sensor_id LIMIT 10;

-- Build a target table to hold data. 
CREATE TABLE sensor_last_restart_agg (
  sensor_id UInt64,
  restart_time SimpleAggregateFunction(max, DateTime)
)
ENGINE = AggregatingMergeTree()
PARTITION BY tuple()
ORDER BY sensor_id

-- Build MV to populate the same. 
CREATE MATERIALIZED VIEW sensor_last_restart
TO sensor_last_restart_agg
AS SELECT
  sensor_id, 
  max(time) AS restart_time
FROM readings_multi
WHERE msg_type = 'restart'
