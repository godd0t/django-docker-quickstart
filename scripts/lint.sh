#!/bin/bash -e

APP_PATH="src"

ruff $APP_PATH
black $APP_PATH --check
