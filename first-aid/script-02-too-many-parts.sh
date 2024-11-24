#!/bin/bash
echo $SHELL
echo 'Trigger too many parts errors'
CCBATCH='clickhouse-client --user=root --password=topsecret -m -n --verbose -t --echo -f PrettyCompact --output_format_pretty_row_numbers=0'


echo 'select 1'|$CCBATCH
for i in {0..100};
do
  echo -n '.'
  $CCBATCH > /dev/null <<- END
    INSERT INTO too_many_parts 
    SELECT 
    intDiv(number, 10000) AS sensor_id,
    now() + INTERVAL intDiv(number, 10000) SECOND AS time,
    toString(sensor_id) || '-' || toString(time) AS message
    FROM numbers_mt(10) SETTINGS parts_to_throw_insert=3
    ;
END
done
