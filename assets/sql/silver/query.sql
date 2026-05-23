CREATE SCHEMA IF NOT EXISTS minio.silver
WITH(
	location = 's3a://etl-data/trino-warehouse/silver/'
);

SELECT * FROM minio.silver.lokasi;
SELECT * FROM minio.silver.cuaca;

CREATE TABLE minio.silver.lokasi(			
    lokasi_id varchar,
	provinsi varchar,
    kabupaten  varchar, 
    kecamatan  varchar,
    desa varchar,
    longitude varchar,
    latitude varchar,
    timezone varchar,
    created_at timestamp,
    updated_at timestamp
)
WITH(
	external_location = 's3a://etl-data/data-lake/silver/lokasi/',
    format = 'PARQUET'
);

CREATE TABLE minio.silver.cuaca(			
    cuaca_id varchar,
	datetime timestamp,
    local_datetime timestamp,
    temperature integer,
    weather_desc varchar,
    humidity integer,
    wind_speed double,
    precipitation double,
    created_at timestamp,
    updated_at timestamp
)
WITH(
	external_location = 's3a://etl-data/data-lake/silver/cuaca/',
    format = 'PARQUET'
);

CREATE TABLE minio.silver.cuaca
WITH(format = 'PARQUET', external_location = 's3a://etl-data/data-lake/silver/cuaca/') AS
SELECT DISTINCT
	to_hex(md5(to_utf8(local_datetime || weather_desc))) AS lokasi_id,
	CAST(REPLACE(REPLACE(datetime, 'T', ' '), 'Z', '') AS TIMESTAMP) AS datetime,
    CAST(local_datetime AS TIMESTAMP) AS local_datetime,
    CAST(t AS INTEGER) AS temperature,
    weather_desc,
    CAST(hu AS INTEGER) AS humidity,
    CAST(ws AS DOUBLE) AS wind_speed,
    CAST(tp AS DOUBLE) AS precipitation
FROM minio.bronze.bmkg

SELECT * FROM minio.silver.lokasi;
DROP TABLE minio.silver.lokasi;

CREATE TABLE minio.silver.lokasi
WITH(format = 'PARQUET', external_location = 's3a://etl-data/data-lake/silver/lokasi/') AS
SELECT DISTINCT	
	to_hex(md5(to_utf8(provinsi || kotkab))) AS lokasi_id,
	TRIM(LOWER(provinsi)) AS provinsi,
    TRIM(LOWER(kotkab)) AS kabupaten,
    TRIM(LOWER(kecamatan)) AS kecamatan ,
    TRIM(LOWER(desa)) AS desa,
    TRIM(lon) AS longitude,
    TRIM(lat) AS latitude,
    TRIM(timezone) AS timezone,
    CAST(now() AS TIMESTAMP) AS created_at,
    CAST(now() AS TIMESTAMP) AS updated_at
FROM minio.bronze.bmkg
