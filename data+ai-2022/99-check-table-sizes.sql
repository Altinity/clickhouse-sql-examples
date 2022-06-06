-- Check table sizes. 
SELECT 
  database AS db, name, total_rows AS rows,
  formatReadableSize(total_bytes) AS size,
  round(total_bytes / rows, 2) AS row_size
FROM system.tables 
WHERE database = currentDatabase() and name LIKE '%readings%' 
ORDER BY name
;

-- Check column sizes.
SELECT table, name,
  formatReadableSize(sum(data_compressed_bytes)) AS tc,
  formatReadableSize(sum(data_uncompressed_bytes)) AS tu
FROM system.columns
WHERE database = currentDatabase() and table LIKE 'readings%' 
GROUP BY table, name ORDER BY table, name
;

