-- Create test data. 
INSERT INTO readings (sensor_id, sensor_type, location, time, reading)
WITH
  toDateTime(toDate('2020-01-01')) as start_time, 
  1000000 as num_sensors,
  365 as num_days,
  24*60 as num_minutes,
  ['Temp Probe', 'NTC Thermistor', 'RTD Sensor', 'Thermocouple'] as sensor_types,
  ['Berkeley', 'Chico', 'Fresno', 'Redding', 'Sacramento', 'Stockton'] as locations,
  num_days * num_minutes as total_minutes
SELECT
  intDiv(number, num_minutes) % num_sensors as sensor_id, 
  sensor_types[sensor_id % length(sensor_types) + 1] as sensor_type,
  locations[sensor_id % length(locations) + 1] as location,
  start_time + (intDiv(number, num_minutes*num_sensors) as day)*24*60*60 + (number % num_minutes as minute)*60 time, 
  60 + 20*sin(cityHash64(sensor_id)) /* median deviation */
  + 15*sin(2*pi()/num_days*day) /* seasonal deviation */  
  + 10*sin(2*pi()/num_minutes*minute)*(1 + rand(1)%100/2000) /* daily deviation */
  + if(sensor_id = 473869 and 
       time between '2020-02-27 13:00:00' and '2020-02-27 13:05:00', -50 + rand(2)%100, 0) 
       /* sensor outage, generates huge error on 2020-02-27 */ 
  as reading
FROM numbers_mt(10000000) /* numbers_mt(525600000000) */ 
SETTINGS max_block_size=1048576;
