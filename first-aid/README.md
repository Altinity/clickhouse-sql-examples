# The Doctor Is In–Quick First Aid for Broken ClickHouse Clusters

This directory has samples used in the Altinity webinar having the same name
as the title. 

## Prerequisites

Set alias for running clickhouse-client. 
```
alias cc-batch='clickhouse-client --user=root --password=topsecret -m -n \
--verbose -t --echo -f PrettyCompact --output_format_pretty_row_numbers=0'
```

## Too Many Connection errors

Install demo-many-01.yaml and run port-forward-many.yaml to open a connection. 

# Examples for User Management in ClickHouse Webinar
