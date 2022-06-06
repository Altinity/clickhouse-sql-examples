-- Check INSERT progress.
SELECT
    query_id,
    written_rows,
    elapsed,
    round(written_rows / elapsed) AS rows_per_sec
FROM system.processes
WHERE query LIKE '%INSERT INTO%'
;
