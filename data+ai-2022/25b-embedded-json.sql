-- Truncate table to ensure we're starting from scratch. 
TRUNCATE TABLE readings_multi_json
;

SET max_insert_threads=4;

-- Select in data from existing table and generate JSON 
-- data. 
INSERT INTO readings_multi_json
SELECT *, 
    toJSONString(map(
      'sensor_id', toString(sensor_id),
      'time', toString(time),
      'msg_type', toString(msg_type),
      'temperature', toString(temperature),
      'message', message,
      'device_type', toString(sensor_id % 50),
      'firmware', 'frx23ID' 
          || leftPad(toString(sensor_id % 1001), 4, '0')
          || 'x' || leftPad(toString(time % 9831), 4, '0')
    ))
    AS json
FROM readings_multi
LIMIT 5000000
;

-- Check data. 
SELECT 
    count(),
    countDistinct(JSONExtractString(json, 'firmware')),
    countDistinct(date),
    countDistinct(sensor_id)
FROM readings_multi_json
;
