#! /bin/bash

# Description:
#   A script that generates a file named `favicon.ico`, which contains multiple
#   layers of different sizes of a file named `favicon.png` (must be
#   present in the current working directory).
#
# Use:
#   ./favicon.sh

main(){
	convert favicon.png \
	\( -clone 0 -resize 16x16 \) \
	\( -clone 0 -resize 32x32 \) \
	\( -clone 0 -resize 48x48 \) \
	\( -clone 0 -resize 57x57 \) \
	\( -clone 0 -resize 64x64 \) \
	\( -clone 0 -resize 72x72 \) \
	\( -clone 0 -resize 110x110 \) \
	\( -clone 0 -resize 114x114 \) \
	\( -clone 0 -resize 120x120 \) \
	\( -clone 0 -resize 128x128 \) \
	\( -clone 0 -resize 144x144 \) \
	\( -clone 0 -resize 152x152 \) \
	favicon.ico
}

main
