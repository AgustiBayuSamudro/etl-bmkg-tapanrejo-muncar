# 🚀 Flow Pipeline Load Api BMKG With Kafka

Melakukan pengambilan data api publik dari bmkg dengan library **beautifulsoup4 dan cloudscraper** dengan menerapkan konsep ETL (Extract Transform Load), untuk data source mengambil dari website public (api.bmkg.go.id) kemudian di ingestion menggunakan **kafka** ke data-lake menggunkana **MINIO**. Proyek ini menggunakan konsep **Medallion architecture** dan **Trino Engine** sebagai pengolah data minio yang sudah di transform.

## ✨ Tools yang digunakan
![GitHub Logo](assets/images/tools.png)
* **Language**: Python
* **Workflow Orchestration**: Apache Airflow
* **Distributed Processing**: PySpark 3.5.0
* **Object Storage**: MinIO
* **Database**: PostgreSQL
* **Data Streaming**: Kafka
* **Data Manipulation**: Spark SQL
* **Environment Management**: Python Dotenv
* **Database Driver**: Psycopg2 Binary
* **Containerization**: Docker & Docker Compose

## 📁 struktur folder
![GitHub Logo](assets/images/struktur-folder.png)

## 🚀 Cara Menjalankan (Quick Start)
Pastikan kamu sudah menginstall **Docker** dan **Docker Compose** di laptopmu.

1. **Clone Repositori**
   ```bash
    https://github.com/AgustiBayuSamudro/etl-bmkg-tapanrejo-muncar.git
2. **Build dan jalankan docker**
   ``` bash
   docker compose up --build -d
3. **Di sini saya menggunakan vps, jika tidak bisa ganti vps dengan localhost**
   ``` bash
   http://103.196.155.168 atau http://localhost
* **MINIO**
    ``` bash
    http://103.196.155.168:9001/
![GitHub Logo](assets/images/minio.jpeg)
* **AIRFLOW**
    ``` bash
    http://103.196.155.168:8080/
![GitHub Logo](assets/images/airflow.jpeg)
* **SPARK**
    ``` bash
    http://103.196.155.168:8081/
![GitHub Logo](assets/images/spark-master.png)
* **Kafka**
    ``` bash
    http://103.196.155.168:8082/
![GitHub Logo](assets/images/kafka.png)

4. **Buat scema pada trino engine**
Struktur schema pada engine Trino yang mengelola data di MinIO:
![GitHub Logo](assets/images/schema.jpeg)

## 🧪 Cara Pengujian (Testing)
1. **Membuat kafka topic**
    ``` bash
    docker exec -it kafka bash
    kafka-topics --create --topic weather-bronze --bootstrap-server kafka:9092

2. **Buat buket pada minio**
    ![GitHub Logo](assets/images/data-lake.jpeg)

3. **Jalankan airlow sampai status runing**

4. **Jalankan query sql yang berada pada**
       ![GitHub Logo](assets/images/struktur-sql.png)
