#!/usr/bin/env bash

read -p "project-id: " PROJECT_ID
read -p "composer-id: " COMPOSER_ID
read -p "composer location: " LOCATION
read -p "absolute path of the YAML file ( leave it empty to use the sample yaml ): " YAML
if [ -z "$YAML" ]
then
      echo "\Using sample YML file"
      YAML="${pwd}/../examples/bq-dag.yml"
fi


FILENAME=$(basename $YAML)


docker run -e PROJECT_ID=$PROJECT_ID -e COMPOSER=$COMPOSER_ID -e LOCATION=$LOCATION -e YAML=$YAML -e FILENAME=$FILENAME -it -v ~/.config/:/root/.config -v ${YAML}:/root/${FILENAME} gcr.io/pso-suchit/auto-compose
