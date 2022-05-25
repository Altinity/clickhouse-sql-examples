# Snowflake to ClickHouse Data Migration

## Introduction

Shows how to migrate data from Snowflake to ClickHouse via S3 using Parguet
files. All examples use AWS. 

## Setup

  1. Create Snowflake account with TPC-DS test data installed. 
  2. Install clickhouse-client. 
  3. Create a Python venv. 

```
# Configure Python environment. 
cd python
sudo apt install -y python3 python3-venv
python3 -m venv .venv
. .venv/bin/activate
pip install --upgrade pip
pip install -r install.txt
```
