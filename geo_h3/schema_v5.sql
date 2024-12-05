CREATE DATABASE geo_tests;

CREATE TABLE geo_tests.cell_towers_landing
(
    `radio` Enum8('Unknown' = 0, 'CDMA' = 1, 'GSM' = 2, 'LTE' = 3, 'NR' = 4, 'UMTS' = 5),
    `mcc` UInt16,
    `net` UInt16,
    `area` UInt16,
    `cell` UInt64,
    `unit` Int16,
    `lon` Float64,
    `lat` Float64,
    `range` UInt32,
    `samples` UInt32,
    `changeable` UInt8,
    `created` DateTime,
    `updated` DateTime,
    `averageSignal` UInt8
)
ENGINE = MergeTree()
ORDER BY (radio, mcc, net, created)
PARTITION BY toYear(created)

-- Ingest it will use 4GB of RAM beware

INSERT INTO geo_tests.cell_towers_landing
SELECT * FROM url('https://altinity-datasets.s3.us-east-005.backblazeb2.com/cell_towers.csv.gz', CSVWithNames);


CREATE TABLE geo_tests.mcc_listing
(
    `countryName` String,
    `countryCode` FixedString(15),
    `mcc` UInt16
)
ENGINE = MergeTree()
ORDER BY tuple()

INSERT INTO geo_tests.mcc_listing
SELECT
    DISTINCT
    countryName AS countryName,
    countryCode AS countryCode,
    toUInt16(mcc) AS mcc
FROM url('https://raw.githubusercontent.com/pbakondy/mcc-mnc-list/refs/heads/master/mcc-mnc-list.json', JSONEachRow);

CREATE DICTIONARY IF NOT EXISTS geo_tests.mcc_listing_dict
(
    `countryName` String,
    `countryCode` String,
    `mcc` UInt64
)
PRIMARY KEY mcc
SOURCE(CLICKHOUSE(TABLE 'mcc_listing' DB 'geo_tests'))
LIFETIME(MIN 180 MAX 300)
LAYOUT(FLAT());


CREATE TABLE geo_tests.cell_towers_h3
(
    `radio` Enum8('Unknown' = 0, 'CDMA' = 1, 'GSM' = 2, 'LTE' = 3, 'NR' = 4, 'UMTS' = 5),
    `country_code` FixedString(15) CODEC(ZSTD(1)),
    `net` UInt16 CODEC(ZSTD(1)),
    `area` UInt16 CODEC(ZSTD(1)),
    `cell` UInt64 CODEC(ZSTD(1)),
    `unit` Int16 CODEC(ZSTD(1)),
    `h3_index` UInt64 CODEC(ZSTD(1)),
    `lon` Float64 CODEC(ZSTD(1)),
    `lat` Float64 CODEC(ZSTD(1)),
    `range` UInt32 CODEC(ZSTD(1)),
    `samples` UInt32 CODEC(ZSTD(1)),
    `created` DateTime CODEC(Delta(4), LZ4),
    `updated` DateTime CODEC(Delta(4), LZ4),
    `averageSignal` UInt8 CODEC(ZSTD(1))
)
ENGINE = MergeTree()
ORDER BY (country_code, h3_index, radio)
PARTITION BY toYear(created);

CREATE MATERIALIZED VIEW geo_tests.cell_towers_h3_mv TO geo_tests.cell_towers_h3
AS
SELECT
    radio AS radio,
    dictGetOrDefault(geo_tests.mcc_listing_dict, 'countryCode', mcc, 0) AS country_code,
    net AS net,
    area AS area,
    cell AS cell,
    unit AS unit,
    geoToH3(lon, lat, 9) AS h3_index,
    lon AS lon,
    lat AS lat,
    range AS range,
    created AS created,
    averageSignal AS averageSignal
FROM geo_tests.cell_towers_landing;

CREATE TABLE geo_tests.world_cities
(
    `name` String,
    `country_code` FixedString(15),
    `admin` String,
    `lon` Float64,
    `lat` Float64,
    `h3_index` UInt64 MATERIALIZED geoToH3(lon, lat, 9)
)
ENGINE = MergeTree()
ORDER BY tuple()

INSERT INTO geo_tests.world_cities
SELECT
    name AS name,
    country AS country_code,
    admin1 AS admin,
    lon AS lon,
    lat AS lat
FROM url('https://raw.githubusercontent.com/lmfmaier/cities-json/refs/heads/master/cities500.json', JSONEachRow);