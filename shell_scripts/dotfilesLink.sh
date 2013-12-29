#! /bin/bash

#   Description:
#       Removes files in $files from ~/, and creates a symlink with identical
#       names to their counterparts in ~/.dotfiles/.

files=(".tmux.conf" ".bashrc" ".zshrc" ".vimrc")

for file in "${files[@]}"
do
	#trim leading period
	if [ "$file[0,1]" = "." ]
	then
	    newFile=${file#*.}
	else
	    newFile=$file
	fi

	printf "Removed ~/$file. "
	printf "Create symlink ~/$file to ~/.dotfiles/$newFile.\n"

	rm ~/$file
	ln -s ~/.dotfiles/$newFile ~/$file
done
