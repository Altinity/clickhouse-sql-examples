-- Use conditional aggregates to make different totals of messages. 

-- Check bounds. 
SELECT min(sensor_id), max(sensor_id), min(time), max(time) from test.readings_multi;

-- Check distribution of values.
SELECT
    toYYYYMM(time) month, 
    countIf(msg_type='reading') AS readings,
    countIf(msg_type='restart') AS restarts,
    min(temperature) as min,
    round(avg(temperature)) as avg,
    max(temperature) as max
FROM test.readings_multi
WHERE sensor_id = 3
GROUP BY month ORDER BY month
;

-- Cheap histogram on temperatures. 
SELECT 
    min(temperature) as min_temp,
    countIf(temperature < 0) AS less_than_32,
    countIf((temperature >= 32) AND (temperature < 70)) AS 32_to_70,
    countIf((temperature >= 70) AND (temperature < 98)) AS 70_to_98,
    countIf((temperature >= 98) AND (temperature < 126)) AS 98_to_126,
    countIf(temperature > 126) AS more_than_126,
    max(temperature) as max_temp
FROM test.readings_multi
WHERE sensor_id = 3

-- Aggregation as join. 
-- CRUDE version, needs cleanup. 
SELECT sensor_id, reading.1, reading.2, restart_time FROM 
(WITH
    256 AS query_sensor_id,
    (
        SELECT max(time)
        FROM test.sensor_last_restart
        WHERE sensor_id = query_sensor_id
    ) AS last_restart_time,
    last_restart_time + 600 AS end_time
SELECT
    sensor_id,
    groupArrayIf((time, temperature), msg_type = 'reading') AS readings,
    anyIf(time, msg_type = 'restart') AS restart_time
FROM test.readings_multi
WHERE (sensor_id = query_sensor_id) AND ((time >= last_restart_time) AND (time <= end_time))
GROUP BY sensor_id)
ARRAY JOIN readings AS reading
;

-- Super-cleaned up version.
SELECT sensor_id, reading_time, temp, restart_time FROM (
WITH 
    toDateTime('2019-01-11 16:00:30') as last_restart_time
SELECT
    sensor_id,
    groupArrayIf(time, msg_type = 'reading') AS reading_time,
    groupArrayIf(temperature, msg_type = 'reading') AS temp,
    anyIf(time, msg_type = 'restart') AS restart_time
FROM test.readings_multi rm
WHERE (sensor_id = 256) 
  AND time BETWEEN last_restart_time AND last_restart_time + 600
GROUP BY sensor_id)
ARRAY JOIN reading_time, temp
;

-- Super-cleaned up version.
SELECT sensor_id, reading_time, temp, 
   reading_time - restart_time AS uptime 
FROM (
WITH 
    toDateTime('2019-01-11 16:00:30') as last_restart_time
SELECT
    sensor_id,
    groupArrayIf(time, msg_type = 'reading') AS reading_time,
    groupArrayIf(temperature, msg_type = 'reading') AS temp,
    anyIf(time, msg_type = 'restart') AS restart_time
FROM test.readings_multi rm
WHERE (sensor_id = 256) 
  AND time BETWEEN last_restart_time AND last_restart_time + 600
GROUP BY sensor_id)
ARRAY JOIN reading_time, temp
;

-- Cleaned-up version. 
SELECT sensor_id, reading_time, temperature, restart_time FROM 
(WITH
    (
        SELECT max(time)
        FROM test.sensor_last_restart
        WHERE sensor_id = 256
    ) AS last_restart_time
SELECT
    sensor_id,
    groupArrayIf(time, msg_type = 'reading') AS reading_time,
    groupArrayIf(temperature, msg_type = 'reading') AS temperature,
    anyIf(time, msg_type = 'restart') AS restart_time
FROM test.readings_multi rm
WHERE (sensor_id = 256) 
  AND ((time >= last_restart_time) AND (time <= last_restart_time + 600))
GROUP BY sensor_id)
ARRAY JOIN reading_time, temperature
;
