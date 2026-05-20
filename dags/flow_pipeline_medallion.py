from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime
import sys

sys.path.append('/opt/airflow/scripts')

def trigger_producer():
    from producer.ingest_data_to_kafka import run_producer
    run_producer()

with DAG(
    dag_id='flow_pipeline_medallion',
    start_date=datetime(2025, 5, 11),
    schedule='@hourly',
    catchup=False,
    tags=['kafka', 'spark', 'medallion']
) as dag:

    ingest_task = PythonOperator(
        task_id='run_scraping_producer',
        python_callable=trigger_producer
    )

    bronze_task = BashOperator(
        task_id='transform_raw_to_bronze',
        bash_command="""
        spark-submit \
        --driver-memory 512m \
        --executor-memory 512m \
        --packages org.apache.hadoop:hadoop-aws:3.3.2,com.amazonaws:aws-java-sdk-bundle:1.11.1026 \
        /opt/airflow/scripts/spark/bronze/bmkg_bronze.py
        """
    )

ingest_task >> bronze_task