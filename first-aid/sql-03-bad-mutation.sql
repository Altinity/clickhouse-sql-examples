DROP TABLE IF EXISTS bad_mutations
;

CREATE TABLE IF NOT EXISTS bad_mutations
(
  `part_id` Int,
  `sensor_id` Int32,
  `time` DateTime,
  `message` String DEFAULT ''
)
ENGINE = MergeTree
PARTITION BY part_id
ORDER BY (sensor_id, time)
;

INSERT INTO bad_mutations 
SELECT 
  number % 25 AS part_id, 
  intDiv(number, 100) AS sensor_id,
  now() + INTERVAL intDiv(number, 10000) SECOND AS time,
  if(part_id % 10 = 0, 'fault', toString(part_id)) AS message
FROM numbers_mt(1000)
SETTINGS max_block_size=10, max_insert_threads=10
;

SELECT partition_id, count(), max(rows), avg(rows), min(rows)
FROM system.parts
WHERE `table` = 'bad_mutations' AND active
GROUP BY partition_id
ORDER BY partition_id ASC
;

ALTER TABLE bad_mutations
    (ADD COLUMN `msg_as_int` UInt32)
;

-- This will get stuck because toInt32 fails on non-numeric values.
ALTER TABLE bad_mutations
  UPDATE msg_as_int = toInt32(message) 
    WHERE (part_id % 2) = 0
;

-- And it will block this mutation that would fix the problem. 
ALTER TABLE bad_mutations
  DELETE WHERE message = 'fault'
;

SELECT * FROM system.mutations FORMAT Vertical
;
