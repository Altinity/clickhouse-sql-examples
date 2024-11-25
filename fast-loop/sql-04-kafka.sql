-- Kafka table engine to read data. 
CREATE TABLE test_kafka (
    `sensor_id` Int32,
    `sensor_type` UInt8,
    `time` DateTime,
    `msg_type` Enum8('reading' = 1, 'restart' = 2, 'err' = 3),
    `temperature` Decimal(5, 2),
    `message` String
) ENGINE = Kafka SETTINGS
  kafka_broker_list = 'kafka-headless.kafka:9092',
  kafka_topic_list = 'test',
  kafka_format = 'CSV'
;

-- Create mat view to transfer data to test table. 
CREATE MATERIALIZED VIEW test_kafka_mv TO test 
AS SELECT
    `sensor_id`, `sensor_type`, `time`, `msg_type`, `temperature`,  `message`
FROM test_kafka;
