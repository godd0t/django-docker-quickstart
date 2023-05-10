#!/bin/bash -e

APP_PATH="src"

black $APP_PATH
ruff $APP_PATH --fix
