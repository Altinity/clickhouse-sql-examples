-- Query to find latest message for a group of devices. 
SELECT message
FROM readings_multi
WHERE (msg_type, sensor_id, time) IN 
   (SELECT msg_type, sensor_id, max(time)
   FROM readings_multi 
   WHERE msg_type = 'err' AND sensor_id = 236
   GROUP BY msg_type, sensor_id)
;

-- Drop aggregation table and view. 
DROP TABLE IF EXISTS sensor_last_restart_agg;
DROP TABLE IF EXISTS sensor_last_restart;

-- Build a target table to hold data. 
CREATE TABLE sensor_last_restart_agg (
  sensor_id Int32,
  time SimpleAggregateFunction(max, DateTime)
)
ENGINE = AggregatingMergeTree()
PARTITION BY tuple()
ORDER BY sensor_id
;

-- Build MV to populate the same. 
CREATE MATERIALIZED VIEW sensor_last_restart
TO sensor_last_restart_agg
AS SELECT
  sensor_id, 
  max(time) AS time
FROM readings_multi
WHERE msg_type = 'restart'
GROUP BY sensor_id
;

-- Load data
INSERT INTO sensor_last_restart
  SELECT sensor_id, max(time)
  FROM readings_multi
  WHERE msg_type = 'restart'
  GROUP BY sensor_id
;

SELECT count() FROM sensor_last_restart_agg;

-- Build a target table to hold error messages. 
DROP TABLE IF EXISTS sensor_last_error_agg;

CREATE TABLE sensor_last_error_agg (
  sensor_id Int32,
  last_time SimpleAggregateFunction(max, DateTime), 
  last_message AggregateFunction(argMax, String, DateTime)
)
ENGINE = AggregatingMergeTree()
PARTITION BY tuple()
ORDER BY sensor_id
;

-- Build MV to populate the same. 
DROP TABLE IF EXISTS sensor_last_error;

CREATE MATERIALIZED VIEW sensor_last_error
TO sensor_last_error_agg
AS SELECT
  sensor_id, 
  max(time) AS last_time,
  argMaxState(message, time) AS last_message
FROM readings_multi rm
WHERE msg_type = 'err'
GROUP BY sensor_id
;

-- Add a couple rows and test that it works. 
INSERT INTO readings_multi(msg_type, sensor_id, time, message) 
VALUES ('err', 236, '2019-01-10 20:00:15', 'Ouch!'), ('err', 255, '2019-01-11 15:00:15', 'Double Ouch!')
;

--
select sensor_id, max(last_time), argMaxMerge(last_message) 
from sensor_last_error group by sensor_id;

