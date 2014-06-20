#   Description:
#       A script to sync ~/music with my connected Blackberry's music directory.
#
#   Use:
#       # connect the blackberry, and:
#       ./bbsync.zsh

blackberry_path="/media/sevko/BLACKBERRY1/home/user/music/Media Sync/"
blackberry_path="${blackberry_path}Compilations/Single/music/"
music_path="$HOME/msc"

if [ ! -d  "$music_path" ]; then
	echo "Music dir '$music_path' not found."
	exit 1
fi

if [ ! -d "$blackberry_path" ]; then
	echo "Blackberry not connected."
	exit 1
fi

# copy any files in dir $1 that aren't in dir $2 into dir $2
sync_dirs(){
	for file in "$1"/*; do
		filename="${file##*/}"
		if [ ! -e "$2/$filename" ]; then
			echo "\tCopying $filename."
			cp "$1/$filename" "$2"
		fi
	done
}

echo "Syncing x1c with blackberry."
sync_dirs "$blackberry_path" "$music_path"

echo "\nSyncing blackberry with x1c."
sync_dirs "$music_path" "$blackberry_path"
