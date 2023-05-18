-- Demo #1
SELECT max(temperature)
FROM test.readings_multi
WHERE sensor_id = 2555 AND msg_type = 'reading';

-- Demo #2
SELECT sensor_id, max(temperature), argMax(date, temperature)
FROM test.readings_multi
WHERE sensor_id = 2555 AND msg_type = 'reading'
GROUP BY sensor_id ;

-- Demo #3
SELECT sensor_id, max(temp_max), argMax(date, temp_max)
FROM test.readings_multi_daily
WHERE sensor_id = 2555 
GROUP BY sensor_id;

-- Demo #4
SELECT sensor_id, reading_time, temp, reading_time, 
  reading_time - restart_time AS uptime
FROM (
WITH toDateTime('2019-04-17 11:00:00') as start_of_range
SELECT sensor_id, groupArrayIf(time, msg_type = 'reading') AS reading_time,
    groupArrayIf(temperature, msg_type = 'reading') AS temp,
    anyIf(time, msg_type = 'restart') AS restart_time
FROM test.readings_multi rm
WHERE (sensor_id = 2555)
  AND time BETWEEN start_of_range AND start_of_range + 600
GROUP BY sensor_id)
ARRAY JOIN reading_time, temp
