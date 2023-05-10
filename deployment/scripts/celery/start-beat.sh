#!/bin/bash

set -o errexit
set -o nounset

celery -A "$APP_NAME" beat -l info
