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

```bash
# Ubuntu/Debian
sudo apt-get install libheif-dev libgtk-3-dev

# Fedora
sudo dnf install libheif-devel gtk3-devel

# Arch Linux
sudo pacman -S libheif gtk3
```

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/marcwadjahdi/heic-converter.git
cd heic-converter
```

2. Build the project:
```bash
./build.sh 0.1.0
```

The executable will be created in the `build` directory.

## Usage

Run the executable and use the graphical dialog to select a HEIC file or folder containing HEIC files. The tool will automatically convert all selected files to JPG format.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 