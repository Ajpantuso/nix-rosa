#!/usr/bin/env bash
set -euo pipefail

echo "Building rosa package..."
nix build .#rosa

echo ""
echo "Testing rosa binary..."
./result/bin/rosa version

echo ""
echo "Checking binary is executable..."
if [ -x ./result/bin/rosa ]; then
  echo "✓ Binary is executable"
else
  echo "✗ Binary is not executable"
  exit 1
fi

echo ""
echo "All tests passed!"
