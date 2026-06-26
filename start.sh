#!/bin/bash
set -e

echo "Building Flutter web app..."
flutter build web --release

echo "Starting web server on port 5000..."
node serve.js
