#! /usr/bin/env bash


cd /opt/airflow/dags/dbt/data_community;
/usr/local/airflow/dbt_env/bin/dbt source freshness --profiles-dir . --target prod

