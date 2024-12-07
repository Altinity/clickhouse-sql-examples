DROP TABLE IF EXISTS test_temp_alerts_rmt;

-- Table to handle alerts. 
CREATE TABLE test_temp_alerts_rmt (
    `alert_id` UInt64, 
    `time` DateTime,
    `temperature` Decimal(5, 2),
    `alert_level` Enum8('moderate' = 1, 'high' = 2, 'critical' = 3),
    `acknowledged` UInt8 DEFAULT 0,
    `effective_date` DateTime DEFAULT now(),
    is_deleted UInt8 DEFAULT 0
) 
Engine=ReplacingMergeTree(effective_date, is_deleted)
PARTITION BY toDate(time)
ORDER BY alert_id;

-- Add an example row to alerts.
INSERT INTO test_temp_alerts_rmt(alert_id, time, temperature, alert_level) VALUES
  (1001, '2024-01-01 20:22:20', 95.6, 3);

SELECT * FROM test_temp_alerts_rmt SETTINGS final = 1 Format Vertical

-- Acknowledge the alert. 
INSERT INTO test_temp_alerts_rmt(alert_id, time, temperature, 
  alert_level, acknowledged) VALUES
  (1001, '2024-01-01 20:22:20', 95.6, 3, 1);

SELECT * FROM test_temp_alerts_rmt SETTINGS final = 1;
