#!/usr/bin/env bash

read -p "project-id: " PROJECT_ID
read -p "composer-id: " COMPOSER_ID
read -p "composer location: " LOCATION
read -p "absolute path of the YAML file ( leave it empty to use the sample yaml ): " YAML

if [ -z "$YAML" ]; then
    echo "\Using sample YML file"
cat > bq-dag.yml <<- "EOL"
default:
  default_args:
    owner: 'default_owner'
    start_date: 2019-08-02
    email: ['suchitpuri@google.com']
    email_on_failure: True
    retries: 1
    email_on_retry: True
  max_active_runs: 1
  schedule_interval: '0 */2 * * *'

bq_dag_complex:
  default_args:
    owner: 'suchitpuri@google.com'
    start_date: 2019-08-02
  description: 'this is an sample bigquery dag which runs every 2 hours'
  tasks:
    query_1:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2018`'
      use_legacy_sql: false
    query_2:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2017`'
      dependencies: [query_1]
      use_legacy_sql: false
    query_3:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2016`'
      dependencies: [query_1]
      use_legacy_sql: false
    query_4:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2015`'
      dependencies: [query_1, query_2]
      use_legacy_sql: false
    query_5:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2014`'
      dependencies: [query_3]
      use_legacy_sql: false

bq_dag_simple:
  default_args:
    owner: 'suchitpuri@google.com'
    start_date: 2018-08-02
  description: 'this is an sample bigquery dag which runs every hour'
  schedule_interval: '0 */1 * * *'
  tasks:
    query_1:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2018`'
      use_legacy_sql: false
    query_2:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2017`'
      dependencies: [query_1]
      use_legacy_sql: false
    query_3:
      operator: airflow.contrib.operators.bigquery_operator.BigQueryOperator
      bql: 'SELECT count(*) FROM `bigquery-public-data.noaa_gsod.gsod2016`'
      dependencies: [query_1]
      use_legacy_sql: false
EOL
     YAML="$(pwd)/bq-dag.yml"
fi

FILENAME=$(basename $YAML)


docker run -e PROJECT_ID=$PROJECT_ID -e COMPOSER=$COMPOSER_ID -e LOCATION=$LOCATION -e YAML=$YAML -e FILENAME=$FILENAME -it -v ~/.config/:/root/.config -v ${YAML}:/root/${FILENAME} gcr.io/pso-suchit/auto-compose