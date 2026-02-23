#!/usr/bin/env bash
set -euo pipefail

FLUTTER_BIN="${FLUTTER_BIN:-/home/titus/development/flutter/bin/flutter}"

echo "[check] Running flutter analyze"
"${FLUTTER_BIN}" analyze

echo "[check] Running flutter test"
"${FLUTTER_BIN}" test

echo "[check] analyze + test passed"
