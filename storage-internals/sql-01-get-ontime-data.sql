-- Create table schema from Altinity.Cloud demo instance. 
DROP TABLE IF EXISTS ontime_demo
;

CREATE TABLE ontime_demo 
  ENGINE = MergeTree()
  PARTITION BY Year
  ORDER BY (Carrier, FlightDate)
  AS 
    SELECT * FROM 
    remoteSecure('clickhouse101.demo.altinity.cloud:9440', default, ontime, 'admin', 'clickhouse1012017')
    WHERE Year in (2018, 2019)
;
