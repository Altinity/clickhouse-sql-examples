#!/usr/bin/env python3
import json
import os
import requests
from requests.auth import HTTPBasicAuth
import sys

# Fill parameters
IEX_API_KEY = None
IEX_TRANSPORT = None
IEX_FILE_NAME = None
try:
    IEX_API_KEY = os.environ['IEX_API_KEY']
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

#IEX_API_KEY = 'pk_fd65d8b16b63421b91be95637b4fc400'
SYMBOLS = ['FB', 'DDOG', 'AAPL', 'AMZN', 'NFLX', 'GOOGL']

def get_quotes(symbols):
    quotes = []
    for i in symbols:
        ticker = i
        api_url = f'https://cloud.iexapis.com/stable/stock/{ticker}/quote?token={IEX_API_KEY}'
        response = requests.get(api_url)
        if response.status_code != 200:
            print("Call failed: Status={} ".format(response.status_code))
        df = response.json()
        print("Data--symbol: {} latestPrice: {}".format(df['symbol'], df['latestPrice']))
        json_data = json.dumps(df)
        quotes.append(json_data)
    return quotes

def write_quotes_to_file(quotes):
    with open(IEX_FILE_NAME, "w") as f:
        for quote in quotes:
            f.write(quote)
    total = len(quotes)
    print(f'Wrote {total} records to {IEX_FILE_NAME}')

#quotes = get_latest_updates('FB', 'AAPL', 'AMZN', 'NFLX', 'GOOGL')
quotes = get_quotes(SYMBOLS)
write_quotes_to_file(quotes)
