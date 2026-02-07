#!/bin/sh
set -e

docker build -t searxng . && docker run --rm -p 8080:8080 --env-file .env searxng
