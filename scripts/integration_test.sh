#!/bin/bash

set -e

if [ ! -d "integration_test" ]; then
    exit 0
fi

# Integration tests require a running device/emulator
# For CI/CD, we skip them as they need Chrome with display
echo "Integration tests skipped in Docker environment"
echo "Run locally with: flutter test integration_test"
exit 0
