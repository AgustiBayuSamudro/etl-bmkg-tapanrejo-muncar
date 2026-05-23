CREATE SCHEMA IF NOT EXISTS minio.gold
WITH(
	location = 's3a://etl-data/trino-warehouse/gold/'
);

SELECT * FROM minio.gold.dim_cuaca;
SELECT * FROM minio.gold.dim_lokasi;

CREATE TABLE minio.gold.dim_cuaca
WITH(format = 'PARQUET', external_location = 's3a://etl-data/data-lake/gold/cuaca/') AS
SELECT * FROM minio.silver.cuaca

CREATE TABLE minio.gold.dim_lokasi
WITH(format = 'PARQUET', external_location = 's3a://etl-data/data-lake/gold/lokasi/') AS
SELECT * FROM minio.silver.lokasi