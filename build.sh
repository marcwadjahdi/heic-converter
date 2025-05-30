#!/bin/bash

# Set the output directory
OUTPUT_DIR="build"

# Check if a version number is provided
if [ -z "$1" ]; then
    echo "Please provide a version number as an argument."
    exit 1
fi

VERSION="$1"
OUTPUT="$OUTPUT_DIR/heic-to-jpg-$VERSION.exe"
SOURCE="main.go"

# Create the build directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Ensure we have the latest dependencies
echo "Updating dependencies..."
go mod tidy

# Check if libheif is installed
if ! pkg-config --exists libheif; then
    echo "Error: libheif is not installed. Please install it first."
    echo "You can install it using: sudo apt-get install libheif-dev"
    exit 1
fi

# Check if the output file exists and if the source file is newer
if [ ! -f $OUTPUT ] || [ $SOURCE -nt $OUTPUT ]; then
    echo "Building the executable..."
    CGO_ENABLED=1 go build -x -o $OUTPUT $SOURCE

    # Check if the build was successful
    if [ $? -eq 0 ]; then
        echo "Build successful: $OUTPUT created."
        chmod +x $OUTPUT
    else
        echo "Build failed. Please check the error messages above."
        echo "Make sure you have all required dependencies installed:"
        echo "sudo apt-get install libheif-dev"
        exit 1
    fi
else
    echo "No changes detected. Skipping build."
fi