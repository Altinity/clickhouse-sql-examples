-- Select rows from a source table. 
DROP TABLE IF EXISTS ontime
;

SET max_insert_threads=4
;
SET max_threads=4
;

CREATE TABLE ontime 
  ENGINE = MergeTree()
  PARTITION BY Year
  ORDER BY (Carrier, FlightDate)
  AS 
    SELECT * FROM ontime_demo
;
