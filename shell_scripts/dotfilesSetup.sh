#! /usr/bin/zsh

# 	Description:
# 		Moves files in $files from ~/ to ~/.dotfiles/, and creates a symlink
# 		named after the "old file" in ~/ to its new counterpart ~/dotfiles/. 
# 		Files in ~/dotfiles/ have their leading period, if any, removed.
# 		
# 	Use:
# 		chmod +x setup.sh
# 		./setup.sh
#
# 		OR
#
# 		`which zsh` setup.sh

files=(".tmux.conf" ".bashrc" ".zshrc" ".vimrc" ".gitconfig")

for file in $files
do
	#trim leading period
	if [ "$file[0,1]" = "." ]
	then
		newFile=${file#*.}
	else
		newFile=$file
	fi

	printf "~/$file moved to ~/.dotfiles/$newFile. "
	printf "Create symlink '~/$file' to ~/.dotfiles/$newFile.\n"

	mv $file .dotfiles/$newFile
	ln -s ~/.dotfiles/$newFile ~/$file
done
