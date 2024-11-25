#!/bin/bash
set -x
INSERT='INSERT+INTO+test+Format+CSVWithNames'
cat test.csv | curl -X POST --data-binary @- \
  "http://localhost:8123/?query=${INSERT}&database=kirpi"

