#!/usr/bin/env bash
set -e

# Fetch dependencies, format code, and run analyzer
flutter pub get
dart format .
flutter analyze || true

echo "Prepare steps finished." 
