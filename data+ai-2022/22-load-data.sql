SET max_insert_threads=32;

SET max_threads=32;

SET optimize_on_insert=0;

SET max_memory_usage=0;

SET max_memory_usage_for_user=0;

-- Create temperature readings. 
INSERT INTO readings_multi (sensor_id, sensor_type, time, msg_type, temperature)
WITH
  toDateTime(toDate('2019-01-01')) as start_time, 
  1000000 as num_sensors,
  --5000 as num_sensors,
  20 as num_sensor_types,
  365 as num_days,
  24*60 as num_minutes,
  num_days * num_minutes as total_minutes
SELECT
  intDiv(number, num_minutes) % num_sensors as sensor_id, 
  sensor_id % num_sensor_types as sensor_type,
  start_time + (intDiv(number, num_minutes*num_sensors) as day)*24*60*60 + (number % num_minutes as minute)*60 as time, 
  'reading' as msg_type, 
  60 + 20*sin(cityHash64(sensor_id)) /* median deviation */
  + 15*sin(2*pi()/num_days*day) /* seasonal deviation */  
  + 10*sin(2*pi()/num_minutes*minute)*(1 + rand(1)%100/2000) /* daily deviation */
  /* Generate erroneous if the time is a multiple of hours * sensor_id */
  + if(time between (start_time + (sensor_id * 3600))
            and  (start_time + (sensor_id * 3600 + 1800)), 
       -50 + rand(2)%100, 0) 
  as temperature
FROM numbers_mt(1000000000000)
SETTINGS max_block_size=1000000;

-- Insert restart events. 
INSERT INTO readings_multi (sensor_id, sensor_type, time, msg_type)
WITH
  toDateTime(toDate('2019-01-01')) as start_time,
  1000000 as num_sensors,
  20 as num_sensor_types,
  365 as num_days,
  24*60 as num_minutes,
  num_days * num_minutes as total_minutes
SELECT 
  intDiv(number, num_minutes) % num_sensors as sensor_id, 
  sensor_id % num_sensor_types as sensor_type,
  start_time + (intDiv(number, num_minutes*num_sensors) as day)*24*60*60 + (number % num_minutes as minute)*60 as time, 
  'restart' as msg_type
FROM numbers_mt(1000000000000)
WHERE time = start_time + (sensor_id * 3600)
SETTINGS max_block_size = 1000000
;  

-- Check bounds. 
SELECT min(sensor_id), max(sensor_id), min(time), max(time) from readings_multi;

-- Check distribution of values.
SELECT
    date, 
    countIf(msg_type='reading') AS readings,
    countIf(msg_type='restart') AS restarts,
    min(temperature) as min,
    avg(temperature) as avg,
    max(temperature) as max
FROM readings_multi
GROUP BY date ORDER BY date;
