-- Clear tables. 
DROP TABLE IF EXISTS readings_multi_json;

-- Readings table with multiple event types. 
CREATE TABLE IF NOT EXISTS readings_multi_json (
    sensor_id Int32 Codec(DoubleDelta, LZ4),
    sensor_type UInt8,
    time DateTime Codec(DoubleDelta, LZ4),
    date ALIAS toDate(time),
    msg_type enum('reading'=1, 'restart'=2, 'err'=3),
    temperature Decimal(5,2) Codec(T64, LZ4),
    message String DEFAULT '',
    json String DEFAULT ''
) Engine = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (msg_type, sensor_id, time);

-- Select in data from existing table. 
INSERT INTO readings_multi_json
SELECT *, 
    toJSONString(map(
      'sensor_id', toString(sensor_id),
      'time', toString(time),
      'msg_type', toString(msg_type),
      'temperature', toString(temperature),
      'message', message,
      'device_type', toString(sensor_id % 50),
      'firmware', 'frx23.' || toString(sensor_id % 75) || '.' || toString(date % 5000)
    ))
    AS json
FROM readings_multi
LIMIT 10
;

SELECT count() FROM readings_multi_json;
