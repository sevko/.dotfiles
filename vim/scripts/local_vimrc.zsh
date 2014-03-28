#! /usr/bin/zsh

pwd=$1
dirs=($(echo ${pwd##$HOME} | tr "/" " "))

for dir in ${(Oa)dirs}; do
	vimrc_path="${pwd%%$dir*}$dir/.vimrc.local"
	if [[ -e "$vimrc_path" ]]; then
		echo -n "$vimrc_path"
		break
	fi
done
