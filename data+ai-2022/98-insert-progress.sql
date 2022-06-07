-- Check INSERT progress.
SELECT
    query_id,
    written_rows,
    read_rows,
    elapsed,
    round(written_rows / elapsed) AS writes_per_sec,
    round(read_rows / elapsed) AS reads_per_sec
FROM system.processes
WHERE query LIKE '%INSERT INTO%'
;
