-- Count exact matches on firmware column. 
SELECT count() 
FROM readings_multi_json
WHERE firmware = 'frx23ID0000x2532'
;

-- Count token matches in JSON. 
SELECT count()
FROM readings_multi_json
WHERE hasToken(json, 'frx23ID0000x2532')
;
