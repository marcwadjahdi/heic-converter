#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT"

# Set the output directory
OUTPUT_DIR="build"

# Check if a version number is provided
if [ -z "$1" ]; then
    echo "Please provide a version number as an argument."
    exit 1
fi

VERSION="$1"
OUTPUT="$OUTPUT_DIR/heic-converter-$VERSION-windows.exe"
SOURCE="main.go"

# Set GOOS and GOARCH for Windows
GOOS="windows"
GOARCH="amd64"

# Check if MinGW is installed
if ! command -v x86_64-w64-mingw32-gcc &>/dev/null; then
    echo "Error: MinGW cross-compiler not found. Please install it first:"
    echo "sudo apt-get install mingw-w64"
    exit 1
fi

# Call the build-libheif script to ensure libheif is set up
if [ -f "$SCRIPT_DIR/build-libheif.sh" ]; then
    echo "Setting up libheif..."
    "$SCRIPT_DIR/build-libheif.sh"
else
    echo "Error: build-libheif.sh not found."
    exit 1
fi

# Set up cross-compilation environment
export CGO_ENABLED=1
export CC=x86_64-w64-mingw32-gcc
export CGO_LDFLAGS="-L/usr/x86_64-w64-mingw32/lib -lheif"
export CGO_CFLAGS="-I/usr/x86_64-w64-mingw32/include"

# Create MinGW directories if they don't exist
sudo mkdir -p /usr/x86_64-w64-mingw32/lib
sudo mkdir -p /usr/x86_64-w64-mingw32/include

# Ensure we have the latest dependencies
echo "Updating dependencies..."
go mod tidy

# Build the executable
if [ ! -f "$OUTPUT" ] || [ "$SOURCE" -nt "$OUTPUT" ]; then
    echo "Building the executable..."
    CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc CGO_LDFLAGS="-L/usr/x86_64-w64-mingw32/lib -lheif" CGO_CFLAGS="-I/usr/x86_64-w64-mingw32/include" GOOS=$GOOS GOARCH=$GOARCH go build -x -o "$OUTPUT" "$SOURCE"

    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Build successful: $OUTPUT created."
        chmod +x "$OUTPUT"
    else
        echo "Build failed. Please check the error messages above."
        exit 1
    fi
else
    echo "No changes detected. Skipping build."
fi
