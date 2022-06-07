set max_insert_threads=2;
set max_threads=2;

-- Copy from base table to optimized tables. 
INSERT INTO readings_lz4
SELECT * EXCEPT (date) FROM readings_unopt
SETTINGS max_block_size=1048576;

INSERT INTO readings_zstd
SELECT * EXCEPT (date) FROM readings_unopt
SETTINGS max_block_size=1048576;

-- Merge excess partitions in optimized tables. 
OPTIMIZE TABLE readings_lz4 FINAL;

OPTIMIZE TABLE readings_zstd FINAL;
