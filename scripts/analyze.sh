#!/bin/bash

set -e

dart format lib test integration_test

if ! flutter analyze --no-fatal-infos; then
    exit 1
fi

exit 0
