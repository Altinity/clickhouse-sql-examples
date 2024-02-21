#!/bin/bash
clickhouse-client --host=${CH_HOST:-localhost} --user=${CH_USER:-demo} \
 --password=${CH_PASSWORD:-demo} -m -n "$@"
