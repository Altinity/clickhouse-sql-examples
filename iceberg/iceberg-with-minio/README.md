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
pip install -r requirements.txt
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

## Creating data to play with

### Using Python

Run the pyiceberg.py script. 

### Using Spark

