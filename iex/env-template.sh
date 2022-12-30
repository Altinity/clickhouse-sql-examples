# Update and source to enable real-time data loading from IEX. 

# API Key for using IEX interface. 
export IEX_API_KEY="your key"

# ClickHouse server connection parameters.
export IEX_CH_URL="http://logos3:8123"
export IEX_CH_USER=demo
export IEX_CH_PASSWORD=demo

# Transport. Choose between file or kafka. 
export IEX_TRANSPORT=file

# Name of file when using file transport. 
export IEX_FILE_NAME=quotes.dat

# Kafka parameters. (To be added)
