#!/bin/bash

# Install required packages
sudo apt-get update
sudo apt-get install -y mingw-w64-tools mingw-w64-x86-64-dev gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 cmake ninja-build \
  libde265-dev:amd64 libx265-dev:amd64 libaom-dev:amd64 libsharpyuv-dev:amd64 \
  libjpeg-dev:amd64 libpng-dev:amd64 libtiff-dev:amd64 zlib1g-dev:amd64 \
  mingw-w64-x86-64-dev-tools

# Create MinGW directories
sudo mkdir -p /usr/x86_64-w64-mingw32/lib
sudo mkdir -p /usr/x86_64-w64-mingw32/include

# Build libheif for Windows
cd dependencies/libheif
sudo rm -rf build-win64
mkdir -p build-win64
cd build-win64

# Configure with MinGW
cmake .. \
  -G Ninja \
  -DCMAKE_SYSTEM_NAME=Windows \
  -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
  -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
  -DCMAKE_FIND_ROOT_PATH=/usr/x86_64-w64-mingw32 \
  -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
  -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
  -DBUILD_SHARED_LIBS=ON \
  -DENABLE_PLUGIN_LOADING=OFF \
  -DWITH_GDK_PIXBUF=OFF \
  -DWITH_EXAMPLES=OFF \
  -DWITH_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr/x86_64-w64-mingw32 \
  -DWITH_LIBDE265=OFF \
  -DWITH_X265=OFF \
  -DWITH_AOM=OFF \
  -DWITH_LIBSHARPYUV=OFF \
  -DWITH_JPEG=OFF \
  -DWITH_PNG=OFF \
  -DWITH_TIFF=OFF \
  -DWITH_ZLIB=OFF

# Build
ninja

# Copy the DLL to MinGW lib directory
sudo cp libheif/libheif.dll /usr/x86_64-w64-mingw32/lib/
sudo cp libheif/libheif.dll.a /usr/x86_64-w64-mingw32/lib/
sudo mkdir -p /usr/x86_64-w64-mingw32/include/libheif
sudo cp -r ../libheif/api/*.h /usr/x86_64-w64-mingw32/include/libheif/

# Create a definition file for libheif
sudo bash -c 'cat > /usr/x86_64-w64-mingw32/lib/libheif.def << EOF
LIBRARY libheif.dll
EXPORTS
    heif_context_alloc
    heif_context_encode_image
    heif_context_free
    heif_context_get_encoder
    heif_context_get_encoder_descriptors
    heif_context_get_image_handle
    heif_context_get_list_of_top_level_image_IDs
    heif_context_get_number_of_top_level_images
    heif_context_get_primary_image_ID
    heif_context_get_primary_image_handle
    heif_context_is_top_level_image_ID
    heif_context_read_from_file
    heif_context_read_from_memory
    heif_context_write_to_file
    heif_decode_image
    heif_decoding_options_alloc
    heif_decoding_options_free
    heif_encoder_descriptor_get_id_name
    heif_encoder_descriptor_get_name
    heif_encoder_release
    heif_encoder_set_logging_level
    heif_encoder_set_lossless
    heif_encoder_set_lossy_quality
    heif_encoding_options_alloc
    heif_encoding_options_free
    heif_get_version
    heif_image_add_plane
    heif_image_create
    heif_image_get_bits_per_pixel
    heif_image_get_bits_per_pixel_range
    heif_image_get_chroma_format
    heif_image_get_colorspace
    heif_image_get_height
    heif_image_get_plane
    heif_image_get_width
    heif_image_handle_get_depth_image_handle
    heif_image_handle_get_height
    heif_image_handle_get_list_of_depth_image_IDs
    heif_image_handle_get_list_of_thumbnail_IDs
    heif_image_handle_get_number_of_depth_images
    heif_image_handle_get_number_of_thumbnails
    heif_image_handle_get_thumbnail
    heif_image_handle_get_width
    heif_image_handle_has_alpha_channel
    heif_image_handle_has_depth_image
    heif_image_handle_is_primary_image
    heif_image_handle_release
    heif_image_release
    heif_image_scale_image
EOF'

# Generate the import library
sudo x86_64-w64-mingw32-dlltool -d /usr/x86_64-w64-mingw32/lib/libheif.def -l /usr/x86_64-w64-mingw32/lib/libheif.dll.a

# Clean up
sudo rm /usr/x86_64-w64-mingw32/lib/libheif.def