-- Drop index. 
ALTER TABLE readings_multi_json DROP INDEX jsonbf;
;

-- Add Bloom filter index. 
ALTER TABLE readings_multi_json
   ADD INDEX jsonbf json TYPE tokenbf_v1(8192, 3, 0) GRANULARITY 1
;

-- Materialize it. 
ALTER TABLE readings_multi_json
    MATERIALIZE INDEX jsonbf
;
