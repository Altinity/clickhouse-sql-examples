#!/bin/bash
mysql --host=${MYSQL_HOST:-localhost} --user=${MYSQL_USER:-demo} --password=${MYSQL_PASSWORD:-demo} -v "$@"
