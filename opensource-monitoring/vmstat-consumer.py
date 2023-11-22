#!/usr/bin/env python3
import io
import os
import requests
from requests.auth import HTTPBasicAuth
import sys
import time

# Fill parameters
MON_CH_URL = MON_USER = MON_CH_USER = None
try:
    MON_CH_URL = os.environ['MON_CH_URL']
    MON_CH_USER = os.environ['MON_CH_USER']
    MON_CH_PASSWORD = os.environ['MON_CH_PASSWORD']
except KeyError as ke:
    print("Required environmental variable not set: {}".format(ke))
    sys.exit(1)

# Set up connection parameters.
auth = HTTPBasicAuth(MON_CH_USER, MON_CH_PASSWORD)
query = "INSERT INTO vmstat Format JSONEachRow"
url_encoded_query = requests.utils.quote(query)
api_url = f'{MON_CH_URL}?database=monitoring&query={url_encoded_query}'

# Read from stdin and dump to ClickHouse every 10 seconds. 
while True:
    # Read lines. 
    buf = io.StringIO()
    for i in range(10):
        line = sys.stdin.readline()
        while line == '':
            time.sleep(1)
            line = sys.stdin.readline()
        buf.write(line)
        print(line)
    buf.seek(0)

    # Load to ClickHouse. 
    response = requests.post(api_url, auth=auth, data=buf)
    print(response.status_code)
    print(response.reason)
    print(response.text)
    if response.status_code != 200:
        print("Call failed: Status={} ".format(response.status_code))
