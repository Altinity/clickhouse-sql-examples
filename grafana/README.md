# Sample Grafana dashboards for Altinity Grafana Plugin for ClickHouse

## Install Grafana on Ubuntu
See https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/
```
sudo apt update
sudo apt install grafana=11.0.0
```

Run this on any Linux host you want to monitor. 

## Installing Grafana dashboard

1. First install Grafana.
2. Add [Altinity Grafana plugin](https://grafana.com/grafana/plugins/vertamedia-clickhouse-datasource/).

## Add data source for Altinity github project

URL: https://github.demo.trial.altinity.cloud:8443
Login: demo
Password: demo

## SQL views for examples. 

Use SQL scripts to create Altinity views. 
```
alias cc-batch='clickhouse-client -m -n --verbose -t --echo -f PrettyCompact --output_format_pretty_row_numbers=0'
```
