#!/bin/bash -e

APP_PATH="src"

ruff $APP_PATH --fix
black $APP_PATH