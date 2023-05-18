-- Check data ranges. 
SELECT 
    count(),
    countDistinct(JSONExtractString(json, 'firmware')),
    countDistinct(date),
    countDistinct(sensor_id)
FROM readings_multi_json
;

-- Materialize firmware property as a column. 
ALTER TABLE readings_multi_json
  ADD COLUMN IF NOT EXISTS firmware String 
    DEFAULT JSONExtractString(json, 'firmware')
;

-- ALTER TABLE readings_multi_json
--   ADD INDEX jsonbf_f1 firmware 
--     TYPE tokenbf_v1(8196, 3, 0) GRANULARITY 1
;

ALTER TABLE readings_multi_json
  UPDATE firmware = firmware WHERE 1=1
;
