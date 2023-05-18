-- Run a heavy query with different numbers of threads. 

SET max_threads=32;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SET max_threads=16;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SET max_threads=8;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SET max_threads=4;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

SET max_threads=2;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

set max_threads=1;

SELECT
    toYYYYMM(time) AS month,
    countIf(msg_type = 'reading') AS readings,
    countIf(msg_type = 'restart') AS restarts,
    min(temperature) AS min,
    round(avg(temperature)) AS avg,
    max(temperature) AS max
FROM test.readings_multi
WHERE (sensor_id >= 0) AND (sensor_id <= 10000)
GROUP BY month ORDER BY month ASC
;

