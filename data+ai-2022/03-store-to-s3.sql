-- Store readings data in S3.

-- Show that we can read parameters.
SELECT {AWS_S3_BUCKET:String}||'/readings_{_partition_id}.dat.gz', hostName();

SELECT {AWS_ACCESS_KEY_ID:String}, hostName();

SELECT {AWS_SECRET_ACCESS_KEY:String}, hostName();

-- INSERT INTO FUNCTION s3({AWS_S3_BUCKET:String}||'/readings_{_partition_id}.dat.gz',
INSERT INTO FUNCTION s3('https://s3.us-east-1.amazonaws.com/altinity-rhodges-demo-1/rhodges-data-ai/data_10B/readings_{_partition_id}.dat.gz',
 Native, 
 'sensor_id Int32, sensor_type String, location String, time DateTime, reading Float32', 'gzip') PARTITION BY rand() % 20
SELECT
    sensor_id,
    sensor_type,
    location,
    time,
    reading
from readings
