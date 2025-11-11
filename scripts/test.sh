#!/bin/bash

set -e

if ! flutter test --coverage --reporter expanded; then
    exit 1
fi

exit 0

exit 0
