#!/bin/bash

set -e

if [ ! -d "integration_test" ]; then
    exit 0
fi

if ! flutter test integration_test --platform chrome --headless; then
    exit 1
fi

exit 0
