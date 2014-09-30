#! /bin/bash

# Description:
#   A script that creates a favicon ICO by creating multiple-sized copies of an
#   input image and overlaying them.
#
# Use:
#   favicon.sh FILENAME
#
#   FILENAME: The favicon image file.

main(){
	# Use `convert` to create different-sized copies of the input image, and
	# then overlay them.

	cmd="convert $1 -resize 256x256"
	for size in 16 32 48 57 64 72 110 114 120 128 144 152; do
		cmd="$cmd ( -clone 0 -resize ${size}x${size} )"
	done
	$cmd favicon.ico
}

main $1
