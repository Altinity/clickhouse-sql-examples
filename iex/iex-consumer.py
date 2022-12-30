#!/usr/bin/env python3
import json
import os
import requests
from requests.auth import HTTPBasicAuth
import sys

# Fill parameters
IEX_CH_URL = IEX_USER = IEX_CH_USER = None
IEX_TRANSPORT = None
IEX_FILE_NAME = None
try:
    IEX_CH_URL = os.environ['IEX_CH_URL']
    IEX_CH_USER = os.environ['IEX_CH_USER']
    IEX_CH_PASSWORD = os.environ['IEX_CH_PASSWORD']

    IEX_TRANSPORT = os.environ['IEX_TRANSPORT']

    IEX_FILE_NAME = os.environ['IEX_FILE_NAME']
except KeyError as ke:
    print("Required environmental variable not set: {}".format(ke))
    sys.exit(1)

# Reality checks. 
if IEX_TRANSPORT == "file":
    if (IEX_FILE_NAME == None) or (not os.path.isfile(IEX_FILE_NAME)):
        print("IEX_FILE_NAME must point to a readable file with JSON IEX data")
        sys.exit(1)
else:
    print("IEX_TRANSPORT must be file")
    sys.exit(1)

# Set up connection parameters.
auth = HTTPBasicAuth(IEX_CH_USER, IEX_CH_PASSWORD)
query = "INSERT INTO iex.quote Format JSONEachRow"
url_encoded_query = requests.utils.quote(query)
api_url = f'{IEX_CH_URL}?database=iex&query={url_encoded_query}'


def load_from_file():
    with open(IEX_FILE_NAME, 'rb') as quotes:
        response = requests.post(api_url, auth=auth, data=quotes)
        print(response.status_code)
        print(response.reason)
        print(response.text)
        if response.status_code != 200:
            print("Call failed: Status={} ".format(response.status_code))

load_from_file()
