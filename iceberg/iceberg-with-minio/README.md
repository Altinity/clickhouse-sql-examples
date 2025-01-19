# Iceberg Data Lake Examples

This directory contains samples for construction an Iceberg-based data 
using Docker Compose. 

## Setup

### Docker

Install Docker Desktop and Docker Compose. 

### Python

Upgrade Python to 3.12. 
```
sudo apt install python3.12 python3.12-venv -y
```

Install Python virtual environment module for your python version. 
```
sudo apt install python3.10-venv
```

Create and invoke the venv. 
```
python3.12 -m venv venv
. ./venv/bin/activate
pip install --upgrade pip
pip install pyarrow pyiceberg pandas
```

## Managing Iceberg Installation

### Bring up the data lake

```
./x-up.sh
```

### Bring down the data lake.

Minio loses its data when you do this even though the volumes are
external. 
```
./x-up.sh
```

### Cleaning up

This deletes all containers and volumes for a fresh start. 
```
./x-clean.sh
```

## Having fun with Iceberg data. 

First, start docker compose and run ClickHouse locally on your laptop. 

### Using Python

Use Python scripts to create and prove you can read data stored in Iceberg. 
They use pyiceberg. 
```
python iceberg_setup.py
python iceberg_read.py
```
These commands create a table in Iceberg named iceberg.bids with 4 rows. 

WARNING: You may need to run these in the lib/python3.x/site-packages 
directory of your virtual environment. There is a bug in some 
environments that prevents pyiceberg libraries from loading properly. 
Copy the scripts into the directory and run them there. 

### Using ClickHouse. 

Connect to ClickHouse and use the following commands to run queries. 
You can access data in 3 different ways. 

#### Direct query on Parquet files. 

You can connect to the Parquet files directly without reading Iceberg 
metadata as follows. You just have to know where the files are located
on S3.
```
SELECT count() 
FROM s3('http://localhost:9002/warehouse/data/data/**/**.parquet', 'minio', 'minio123')

SELECT * 
FROM s3('http://localhost:9002/warehouse/data/data/**/**.parquet', 'minio', 'minio123')
```
Both of them read all files from all Iceberg snapshots. If you remove 
or change data they won't give the right answer. 

#### Query using Iceberg metadata without a catalog

Use the icebergS3 table function if you want to avoid specifying the
exact location of files. 

```
SELECT count()
FROM icebergS3('http://localhost:9002/warehouse/data', 'minio', 'minio123')

SELECT *
FROM icebergS3('http://localhost:9002/warehouse/data', 'minio', 'minio123')
```

#### Query using the Iceberg REST catalog

Create an Iceberg database. This is the easiest way to locate data. 

```
DROP DATABASE IF EXISTS datalake
;
SET allow_experimental_database_iceberg=true
;
CREATE DATABASE datalake
ENGINE = Iceberg('http://localhost:8182/v1', 'minio', 'minio123')
SETTINGS catalog_type = 'rest', storage_endpoint = 'http://localhost:9002/warehouse', warehouse = 'iceberg' 
;
SHOW TABLES from datalake
;
SELECT count() FROM datalake.`iceberg.bids`
;
SELECT * FROM datalake.`iceberg.bids`
```

### Using Spark

Connect to the spark-iceberg container command line. 
```
docker exec -it $(docker ps -f name=spark-iceberg -q) /bin/bash
```

Start the Spark scala shell. Do not be alarmed by its slowness. 
```
spark-shell \
--conf spark.sql.catalog.rest_prod=org.apache.iceberg.spark.SparkCatalog \
--conf spark.sql.catalog.rest_prod.type=rest \
--conf spark.sql.catalog.rest_prod.uri=http://rest:8080
```

Read data and prove you can change it as well by running the commands below. 
```
spark.sql("SHOW NAMESPACES").show()
spark.sql("SHOW TABLES FROM iceberg").show()
spark.sql("SHOW CREATE TABLE iceberg.bids").show(truncate=false)
spark.sql("SELECT * FROM iceberg.bids").show()
spark.sql("DELETE FROM iceberg.bids WHERE bid < 198.23").show()
spark.sql("SELECT * FROM iceberg.bids").show()
```

Try selecting data each of the three ways in ClickHouse to see which of them 
still give the right answers. 
