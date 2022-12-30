#!/bin/bash
set -e
. env.sh
for i in {1..10}; do
  echo "---------------"
  echo "---ITERATON: $i"
  echo "---------------"
  ./iex-producer.py
  ./iex-consumer.py
  sleep 9
done
