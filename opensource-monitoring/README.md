# Sample scripts for open source monitoring

## Setting up in ClickHouse

```
# Adjust credentials in script. 
./load_schema.sh
```

## Loading data from host.

Adjust env.sh to add URL and credentials for your ClickHouse server. Then:

```
nohup ./run.sh > nohup.out 2>&1 &
```
