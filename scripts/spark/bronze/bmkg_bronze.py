from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Bmkg_Bronze") \
    .getOrCreate()

sc = spark.sparkContext
hadoop_conf = sc._jsc.hadoopConfiguration()

hadoop_conf.set("fs.s3a.endpoint", "http://minio:9000")
hadoop_conf.set("fs.s3a.access.key", "minio")
hadoop_conf.set("fs.s3a.secret.key", "minio123")
hadoop_conf.set("fs.s3a.path.style.access", "true")
hadoop_conf.set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")

df_raw = spark.read.json(
    "s3a://etl-data/data-lake/raw/bmkg/*.json"
)

df_raw.createOrReplaceTempView("raw_bmkg")

json_ddl_schema = (
    "lokasi STRUCT<provinsi:STRING,kotkab:STRING,kecamatan:STRING,desa:STRING,lon:STRING,lat:STRING,timezone:STRING>,"
    "data ARRAY<STRUCT<cuaca:ARRAY<ARRAY<STRUCT<datetime:STRING,local_datetime:STRING,t:STRING,weather_desc:STRING,hu:STRING,ws:STRING,tp:STRING>>>>>"
)

df_bronze = spark.sql(f"""
    WITH base_parsed AS (
        SELECT from_json(value, '{json_ddl_schema}') AS parsed
        FROM raw_bmkg
    ),
    flattened_lokasi AS (
        -- Isolasi dan amankan kolom-kolom tingkat atas dulu di sini
        SELECT 
            parsed.lokasi.provinsi AS provinsi,
            parsed.lokasi.kotkab AS kotkab,
            parsed.lokasi.kecamatan AS kecamatan,
            parsed.lokasi.desa AS desa,
            parsed.lokasi.lon AS lon,
            parsed.lokasi.lat AS lat,
            parsed.lokasi.timezone AS timezone,
            parsed.data AS array_data
        FROM base_parsed
    )
    SELECT 
        f.provinsi,
        f.kotkab,
        f.kecamatan,
        f.desa,
        f.lon,
        f.lat,
        f.timezone,                
        tiap_waktu.datetime,
        tiap_waktu.local_datetime,
        tiap_waktu.t,
        tiap_waktu.weather_desc,
        tiap_waktu.hu,
        tiap_waktu.ws,
        tiap_waktu.tp 
    FROM flattened_lokasi f
    LATERAL VIEW explode(f.array_data) t1 AS grup_data
    LATERAL VIEW explode(grup_data.cuaca) t2 AS list_cuaca
    LATERAL VIEW explode(list_cuaca) t3 AS tiap_waktu
""")

output_path = "s3a://etl-data/data-lake/bronze/bmkg"

df_bronze.write \
    .mode("overwrite") \
    .parquet(output_path)

print(f"Berhasil! Data bronze bmkg tersimpan di: {output_path}")

spark.stop()