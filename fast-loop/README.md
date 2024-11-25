# Building fast data loops from insert to query response in ClickHouse

This directory has samples used in the Altinity webinar having the same name
as the title. 

## Prerequisites

Set alias for running clickhouse-client. 
```
alias cc-batch='clickhouse-client --user=root --password=topsecret -m -n \
--verbose -t --echo -f PrettyCompact --output_format_pretty_row_numbers=0'
```

You can run scripts as follows. 
```
cc-batch < sql-01-base-table.sql
```
