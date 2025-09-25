#!/bin/bash
set -e  # Exit on error

# Move to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Create and enter build directory
mkdir -p build
cd build

# Run cmake and make
cmake ..
make

echo "✅ Build output:"
ls -lh *.elf *.bin

