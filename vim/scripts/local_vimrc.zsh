#! /usr/bin/zsh

#   Description:
#       Search up the filesystem tree from the argument directory to the $HOME
#       directory, and print the path of the first ".vimrc.local" file found.
#       Print nothing if there aren't any.
#
#   Use:
#       ./local_vimrc.zsh

if [ "$1" = "" ]; then
	echo "Command-line argument required."
	exit 1
fi

pwd=$1
dirs=($(echo ${pwd##$HOME} | tr "/" " "))

for dir in ${(Oa)dirs}; do
	vimrc_path="${pwd%%$dir*}$dir/.vimrc.local"
	if [[ -e "$vimrc_path" ]]; then
		echo -n "$vimrc_path"
		break
	fi
done
