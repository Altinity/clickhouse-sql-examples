# Generate ClickHouse SQL to load Parquet data from S3

## Introduction

Generates CREATE TABLE and INSERT commands to read Parquet files. 

## Assumptions

Parquet files are stored in S3 using a path with the following form:

  s3://bucket/dir1/.../dirN/table_name/<parquet files>

## Setup

Configure Python and create a virtual environment. This is tested with 
Python 3.6.9 but should work for other versions. 

```
python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Set environment

Copy env.sh.template to env.sh and set environmental variables found therein. 
Run `. env.sh` to set values. 

## Run generator. 

Execute the generation script. 
```
python generate-ch-schema.py
```

Execute the resulting commands in ClickHouse to create the table and read 
Parquet data from S3. 
