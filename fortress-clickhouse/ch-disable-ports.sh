#!/bin/bash
# Show how to disable unwanted ports. 
mkdir -p data/conf.d
cat << EOF > data/conf.d/disable_mysql_and_postgresql_ports.xml
<clickhouse>
   <!-- Disable MySQL and PostreSQL emulation ports -->
   <mysql_port remove="true"/>
   <postgresql_port remove="true"/>   
</clickhouse>
EOF
