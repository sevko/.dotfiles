#! /bin/bash

#   Description:
#       Removes ~/$files and creates symlinks with identical names to their
#       counterparts in ~/.dotfiles/.

source termColorsFonts.sh

files=(".tmux.conf" ".bashrc" ".zshrc" ".vimrc" ".gitconfig")

errorString="$font[bold]$(fg 196)x$font[reset]"
successString="$font[bold]$(fg 46)+$font[reset]"

for file in "${files[@]}"
do
	#trim leading period
	if [ "$file[0,1]" = "." ]
	then
	    newFile=${file#*.}
	else
	    newFile=$file
	fi

	printf "Remove $file: "
	(rm ~/$file &> /dev/null && printf successString) || printf errorString

	printf "\tCreate symlink $file to ~/.dotfiles/$newFile: "
	(ln -s ~/.dotfiles/$newFile ~/$file &> /dev/null && printf successString) || printf errorString

	printf "\n"
done
