#!/bin/bash
. env.sh
set -ex
./vmstat-producer.py | ./vmstat-consumer.py 
