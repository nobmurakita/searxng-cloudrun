#!/bin/sh
set -e

SERVICE_NAME="${1:-searxng}"

PROJECT_FLAG=""
if [ -n "$2" ]; then
    PROJECT_FLAG="--project $2"
fi

gcloud run deploy "$SERVICE_NAME" \
  --source . \
  --execution-environment gen2 \
  --allow-unauthenticated \
  --startup-probe httpGet.path=/healthz,periodSeconds=1,failureThreshold=30 \
  --env-vars-file .env \
  --region asia-northeast1 \
  $PROJECT_FLAG
