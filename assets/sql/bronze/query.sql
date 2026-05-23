CREATE SCHEMA IF NOT EXISTS minio.bronze
WITH(
	location = 's3a://etl-data/trino-warehouse/bronze/'
);

SELECT * FROM minio.bronze.bmkg;

DROP TABLE minio.bronze.bmkg;

CREATE TABLE minio.bronze.bmkg(			
        provinsi VARCHAR,
        kotkab VARCHAR,
        kecamatan VARCHAR,
        desa VARCHAR,
        lon VARCHAR,
        lat VARCHAR,
        timezone VARCHAR,                
        datetime VARCHAR,
        local_datetime VARCHAR,
        t VARCHAR,
        weather_desc VARCHAR,
        hu VARCHAR,
        ws VARCHAR,
        tp VARCHAR
)
WITH(
	external_location = 's3a://etl-data/data-lake/bronze/bmkg/',
    format = 'PARQUET'
);

