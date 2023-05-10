#!/bin/bash -e

APP_PATH="src"

black $APP_PATH --check
ruff $APP_PATH
