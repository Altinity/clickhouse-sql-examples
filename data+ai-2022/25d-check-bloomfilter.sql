-- Count exact matches. 
SELECT count() 
FROM readings_multi_json
WHERE firmware = '%frx23ID0000x2532%'
;

-- Count substring matches. 
SELECT count()
FROM readings_multi_json
WHERE json LIKE '%frx23ID0000x2532%'
;
