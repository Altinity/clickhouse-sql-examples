#!/bin/bash
set -x
INSERT='INSERT%20INTO%20fluentbit_null%20Format%20JSONAsString'
curl -X POST --data-binary @- \
  "http://logos3:8123/?database=monitoring&query=${INSERT}" <<END
{"timestamp":1707016301,"cpu_p":8.0,"user_p":5.5,"system_p":2.5,"cpu0.p_cpu":7.0,"cpu0.p_user":6.0,"cpu0.p_system":1.0,"cpu1.p_cpu":10.0,"cpu1.p_user":6.0,"cpu1.p_system":4.0,"cpu2.p_cpu":8.0,"cpu2.p_user":5.0,"cpu2.p_system":3.0,"cpu3.p_cpu":6.0,"cpu3.p_user":6.0,"cpu3.p_system":0.0,"cpu4.p_cpu":10.0,"cpu4.p_user":6.0,"cpu4.p_system":4.0,"cpu5.p_cpu":7.0,"cpu5.p_user":6.0,"cpu5.p_system":1.0,"cpu6.p_cpu":7.0,"cpu6.p_user":4.0,"cpu6.p_system":3.0,"cpu7.p_cpu":10.0,"cpu7.p_user":5.0,"cpu7.p_system":5.0,"hostname":"logos2"}
END
