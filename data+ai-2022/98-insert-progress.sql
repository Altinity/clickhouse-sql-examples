-- Check INSERT progress.
SELECT
    query_id,
    written_rows,
    read_rows,
    elapsed,
    round(written_rows / elapsed) AS writes_per_sec,
    round(read_rows / elapsed) AS reads_per_sec,
    (1000000000000 - written_rows)/ writes_per_sec AS est_remaining_secs
FROM system.processes
WHERE query LIKE '%INSERT INTO%' AND elapsed > 1.0
FORMAT Vertical
;
