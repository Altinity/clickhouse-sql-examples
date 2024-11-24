# Sample scripts for open source monitoring

## Setting up in ClickHouse

These are demo script that run on a home dev server. You'll need to 
change credentials, use TLS, etc., to deploy them. I hope you find the
samples useful. 

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
stress -m 8 --vm-bytes 4G --timeout 60
```

## Using SQL to find out interesting things

Once you have data loaded you can ask any question you want in SQL. 
Here's how to find hosts that had more than 25% load in the last day. 
```
SELECT host, count() AS loaded_minutes
FROM (
    SELECT
        toStartOfMinute(timestamp) AS minute, host, avg(100 - id) AS load
    FROM monitoring.vmstat
    WHERE timestamp > (now() - toIntervalDay(1))
    GROUP BY minute, host HAVING load > 25
)
GROUP BY host ORDER BY loaded_minutes DESC
```

## Using Fluent Bit

You can also use Fluenti Bit to collect data. Here's how to try it out. 

1. Install [Fluent Bit](https://docs.fluentbit.io/manual/installation/getting-started-with-fluent-bit). 
2. Run load_fluentbit_schema.sh to create a table for Fluent Bit CPU data. 
3. Start Fluent Bit: `fluentbit -c fluent-http.conf`

Don't for get to modify the credentials and ClickHouse server location in fluent-http.conf. 

## Demo commands

Set up ssh tunneling. 
```
ssh -L 9000:logos3:9000 -L 3000:logos3vmstat:3000 -L 8123:logos3:8123 logos2
```

Show how to generate data. 
```
vmstat
more vmstat-producer.py
./vmstat-producer.py
more vmstat-consumer.py
curl http://logos3:8123?query='select+version()'
```

Put some load on the system!
```
stress -m 6 --vm-bytes 4G --timeout 60
```

Run a query to see how the system has been loaded recently. 
```
SELECT host, count() AS loaded_minutes
FROM (
    SELECT
        toStartOfMinute(timestamp) AS minute, host, avg(100 - id) AS load
    FROM monitoring.vmstat
    WHERE timestamp > (now() - toIntervalDay(1))
    GROUP BY minute, host HAVING load > 25
)
GROUP BY host ORDER BY loaded_minutes DESC
```
