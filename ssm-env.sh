#!/bin/sh

# Loads environment variables from AWS SSM Parameter Store.
# Requires aws-env to be installed on host.
# https://github.com/Droplr/aws-env

set -e

if [ -z "$ENV_SLUG" ] || [ -z "$APP_NAME" ] || [ -z "$AWS_REGION" ]; then
  echo "Skipping ssm-env.sh."
  echo "Either of ENV_SLUG, APP_NAME or AWS_REGION were not provided."
  echo "Received ENV_SLUG=\"$ENV_SLUG\", APP_NAME=\"$APP_NAME\", AWS_REGION=\"$AWS_REGION\""
else
  # Load app specific environment variables
  AWS_ENV_PATH="/$ENV_SLUG/$APP_NAME/" aws-env --format=dotenv >.env

  # Load common environment variables
  AWS_ENV_PATH="/$ENV_SLUG/common/" aws-env --format=dotenv >>.env
fi
