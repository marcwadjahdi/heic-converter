#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check if a target OS and version number are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Please provide a target OS (linux/windows) and a version number as arguments."
    exit 1
fi

TARGET_OS="$1"

# Call the appropriate build script based on the target OS
if [ "$TARGET_OS" == "windows" ]; then
    ./build-windows.sh "$2"
elif [ "$TARGET_OS" == "linux" ]; then
    ./build-linux.sh "$2"
else
    echo "Error: Unsupported target OS. Please specify 'linux' or 'windows'."
    exit 1
fi
