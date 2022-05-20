#!/bin/bash
[[ x"${CH_HOST}" == "x" ]] && echo "CH_HOST not set" && exit 1
[[ x"${CH_USER}" == "x" ]] && echo "CH_USER not set" && exit 1
[[ x"${CH_PASSWORD}" == "x" ]] && echo "CH_PASSWORD not set" && exit 1

# Run multi-line queries and echo them. 
clickhouse-client --host="${CH_HOST}" --port=9440 -s --user="${CH_USER}" --password="${CH_PASSWORD}" --echo --multiline --multiquery "$@"
