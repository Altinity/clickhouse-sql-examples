DROP TABLE IF EXISTS too_many_parts
;

CREATE TABLE IF NOT EXISTS too_many_parts
(
  `sensor_id` Int32,
  `time` DateTime,
  `message` String DEFAULT ''
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(time)
ORDER BY (sensor_id, time)
;

INSERT INTO too_many_parts 
SELECT 
  intDiv(number, 10000) AS sensor_id,
  now() + INTERVAL intDiv(number, 10000) SECOND AS time,
  toString(sensor_id) || '-' || toString(time) AS message
FROM numbers_mt(1000000)
SETTINGS max_block_size=10, max_insert_threads=10
;

SELECT partition_id, count(), max(rows), avg(rows), min(rows)
FROM system.parts
WHERE `table` = 'too_many_parts'
GROUP BY partition_id
ORDER BY partition_id ASC
;

