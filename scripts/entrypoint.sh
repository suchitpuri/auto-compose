#!/usr/bin/env bash

gcloud config set project $PROJECT_ID
export DAG_LOCATION=`gcloud composer environments describe $COMPOSER --location=$LOCATION --format="json" | python3 -c "import sys, json; print(json.load(sys.stdin)['config']['dagGcsPrefix'])"`
echo $DAG_LOCATION


