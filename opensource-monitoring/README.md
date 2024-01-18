# Sample scripts for open source monitoring

## Setting up in ClickHouse

```
# Adjust credentials in script. 
./load_schema.sh
```

## Loading data from host

Adjust env.sh to add URL and credentials for your ClickHouse server. Then:

```
nohup ./run.sh > nohup.out 2>&1 &
```

Run this on any Linux host you want to monitor. 

## Installing Grafana dashboard

1. Install Grafana.
2. Add [Altinity Grafana plugin](https://grafana.com/grafana/plugins/vertamedia-clickhouse-datasource/).
3. Create ClickHouse data source named 'ClickHouse Monitoring' pointing to ClickHouse server.
4. Import dashboard Host-Performance-Dashboard-20231123.json.

## Generating interesting data. 

Sysbench can generate load. Run `sudo apt install sysbench` to install. 
You can then run tests to beat up on servers. Use a command like this
to stress the CPU. 
```
sysbench cpu --threads=4 --time=120 run
```

Install and run stress (`sudo apt install stress`) to eat up memory. 
```
stress -m 4 --vm-bytes 4G
```
