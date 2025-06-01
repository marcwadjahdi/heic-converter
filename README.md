# HEIC to JPG Converter

A simple command-line tool to convert HEIC images to JPG format. This tool provides a graphical interface for selecting files or folders to convert.

## Features

- Convert HEIC images to JPG format
- Support for both single file and directory conversion
- Graphical file/folder selection dialog
- Concurrent conversion with limited thread count
- Cross-platform support

## Requirements

- Go 1.23 or higher
- libheif development libraries
- GTK3 (for the file dialog)

## Installation

### Prerequisites

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install libheif-dev libgtk-3-dev
```

#### Windows (Cross-compilation from Linux)
```bash
# Install required packages
sudo apt-get install -y build-essential cmake pkg-config mingw-w64-x86-64-dev libheif-dev golang-go

# Install libheif for Windows
./scripts/build-libheif-win.sh
```

The `build-libheif-win.sh` script will:
1. Install MinGW development tools
2. Build libheif for Windows
3. Install the DLL and import library in the MinGW system directory
4. Create necessary import libraries for linking

The script builds a minimal version of libheif without optional dependencies (like JPEG, PNG, etc.) to keep the DLL size small and dependencies minimal.

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/marcwadjahdi/heic-converter.git
cd heic-converter
```

2. Build the project:
```bash
# For Linux
./scripts/build.sh 0.1.0 linux

# For Windows
./scripts/build.sh 0.1.0 windows
```

The executables will be created in the `build` directory:
- Linux: `build/heic-converter-0.1.0`
- Windows: `build/heic-converter-0.1.0-windows/` (includes required DLL)

## Usage

Run the executable and use the graphical dialog to select a HEIC file or folder containing HEIC files. The tool will automatically convert all selected files to JPG format.

For Windows users: Make sure to keep the `libheif.dll` file in the same directory as the executable.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 